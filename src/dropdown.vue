// out: ..
<template lang="jade">
ul(:style="style" v-if="opened" @click.prevent="onClick" @keyup.esc="close | notPrevented | prevent" v-el:dd v-bind:class="[class]")
  slot No content
</template>

<script lang="coffee">
module.exports =

  mixins:[
    require("vue-mixins/getViewportSize")
    require("vue-mixins/onceDocument")
    require("vue-mixins/isOpened")
    require("vue-mixins/parentListener")
  ]

  filters:
    notPrevented: require("vue-filters/notPrevented")
    prevent: require("vue-filters/prevent")

  props:
    "class":
      type: String
      default: "dropdown-content"
    "notDissmissible":
      type: Boolean
      default: false
    "notCloseOnClick":
      type: Boolean
      default: false
    "constrainWidth":
      type: Boolean
      default: false
    "overlay":
      type: Boolean
      default: false
    "offset":
      type: Number
      default: 0
    "anchor":
      type: String
    "transitionIn":
      type: Function
      default: ({el,cb}) ->
        @style.opacity = 1
        cb()
    "transitionOut":
      type: Function
      default: ({el,cb}) ->
        @style.opacity = 0
        cb()

  data: ->
    removeDocumentClickListener: null
    clickInside: false
    removeTimeout: null
    style:
      position: "absolute"
      opacity: 0
      left: undefined
      top: undefined
      display: "block"



  methods:
    onClick: (e) ->
      @setClickInside()

    onParentClick: (e) ->
      return if e.defaultPrevented
      @setClickInside()
      if @opened
        @close()
      else
        @open()
      e.preventDefault()

    setClickInside: ->
      @clickInside = true
      @removeTimeout?()
      @removeTimeout = setTimeout (=>@clickInside = false),10
      @close() unless @notCloseOnClick



    show: ->
      return if @opened
      @setOpened()
      @$nextTick => @$nextTick =>
        if @constrainWidth
          width = @parent.offsetWidth
          @style.width = width-@offset+'px'
        else
          width = @$els.dd.offsetWidth
          @style.width = undefined
        totalHeight = @$els.dd.offsetHeight
        totalHeight += @parent.offsetHeight unless @overlay

        parentStyle = getComputedStyle(@parent)
        parentIsPositioned = /relative|absolute|fixed/.test(parentStyle.getPropertyValue("position"))
        parentPos = @parent.getBoundingClientRect()
        windowSize = @getViewportSize()

        asTop = true
        if (@anchor[0] == "n" and @overlay) or (@anchor[0] == "s" and not @overlay)
          asTop = parentPos.top + totalHeight <= windowSize.height
        else
          asTop = parentPos.bottom + totalHeight <= 0
        top = 0
        topBorder = parseInt(parentStyle.getPropertyValue("border-top-width").replace("px",""))
        if asTop
          unless @overlay
            top = @parent.clientHeight + topBorder
          else
            top = -topBorder
        else
          top = -totalHeight + @parent.offsetHeight - topBorder
        top += @parent.offsetTop unless parentIsPositioned
        @style.top = top + "px"

        asLeft = true
        left = @offset
        if @anchor[1] == "e"
          asLeft = parentPos.right + width > 0
          left += @parent.offsetWidth - width
        else
          asLeft = parentPos.left + width <= windowSize.width
        if asLeft
          left -= parseInt(parentStyle.getPropertyValue("border-left-width").replace("px",""))
        else
          left -= @parent.clientWidth - parseInt(parentStyle.getPropertyValue("border-left-width").replace("px","")) - parseInt(parentStyle.getPropertyValue("border-right-width").replace("px",""))
        left += @parent.offsetLeft unless parentIsPositioned
        @style.left = left + "px"

        unless @notDissmissible
          @removeDocumentClickListener?()
          @removeDocumentClickListener = @onceDocument "click", (e) =>
            @hide() unless @clickInside
            return !@clickInside #should remove?

        @$emit "beforeOpen"
        @transitionIn el:@$els.dd,cb: =>
          @$emit "opened"

    hide: ->
      return unless @opened
      @removeDocumentClickListener?()
      @removeDocumentClickListener = null
      @$emit "beforeClose"
      @transitionOut el:@$els.dd, cb: =>
        @setClosed()
        @$emit "closed"

    open: ->
      @show()

    close: ->
      @hide()

    toggle:  ->
      if @opened
        @close()
      else
        @open()
  compiled: ->
    unless @anchor
      @anchor = if @overlay then "nw" else "sw"


  dettached: ->
    @removeDocumentClickListener?()

  events:
    close: ->
      @close()
      return true
</script>

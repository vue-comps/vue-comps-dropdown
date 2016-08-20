// out: ..
<template lang="pug">
ul(v-bind:style="computedStyle" v-bind:id="id" v-if="opened" @click="onClick" @keyup.esc="close" v-el:dd v-bind:class="computedClass")
  slot No content
</template>

<script lang="coffee">
module.exports =

  mixins:[
    require("vue-mixins/getViewportSize")
    require("vue-mixins/onceDocument")
    require("vue-mixins/isOpened")
    require("vue-mixins/parentListener")
    require("vue-mixins/class")
    require("vue-mixins/style")
  ]


  props:
    "id":
      type: String
    "class":
      default: -> []
    "style":
      default: -> []
    "notDismissable":
      type: Boolean
      default: false
    "closeOnClick":
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
      coerce: Number
    "anchor":
      type: String
    "transitionIn":
      type: Function
      default: ({el,cb}) ->
        @mergeStyle.opacity = 1
        cb()
    "transitionOut":
      type: Function
      default: ({el,cb}) ->
        @mergeStyle.opacity = 0
        cb()

  data: ->
    removeDocumentClickListener: null
    clickInside: false
    removeTimeout: null
    mergeStyle:
      position: "absolute"
      opacity: 0
      left: undefined
      top: undefined
      display: "block"

  computed:
    cAnchor: ->
      return @anchor if @anchor
      return "nw" if @overlay
      return "sw"

  methods:
    onClick: (e) ->
      e.preventDefault()
      @setClickInside()

    onParentClick: (e) ->
      return if e.defaultPrevented
      e.preventDefault()
      @setClickInside()
      if @opened
        @close()
      else
        @open()


    setClickInside: ->
      @clickInside = true
      @removeTimeout?()
      @removeTimeout = setTimeout (=>@clickInside = false),10
      @close() if @closeOnClick



    show: ->
      return if @opened
      @setOpened()
      @$nextTick => @$nextTick =>
        if @constrainWidth
          width = @parent.offsetWidth
          @mergeStyle.width = width-@offset+'px'
        else
          width = @$els.dd.offsetWidth
          @mergeStyle.width = undefined
        totalHeight = @$els.dd.offsetHeight
        totalHeight += @parent.offsetHeight unless @overlay

        parentStyle = getComputedStyle(@parent)
        parentIsPositioned = /relative|absolute|fixed/.test(parentStyle.getPropertyValue("position"))
        parentPos = @parent.getBoundingClientRect()
        windowSize = @getViewportSize()

        asTop = true
        if (@cAnchor[0] == "n" and @overlay) or (@cAnchor[0] == "s" and not @overlay)
          asTop = parentPos.top + totalHeight <= windowSize.height
        else
          asTop = parentPos.bottom - totalHeight <= 0
        top = 0
        topBorder = parseInt(parentStyle.getPropertyValue("border-top-width").replace("px",""))
        if asTop
          unless @overlay
            top = @parent.clientHeight + topBorder
          else
            top = -topBorder
          unless parentIsPositioned
            bottomBorder = parseInt(parentStyle.getPropertyValue("border-bottom-width").replace("px",""))
            top += bottomBorder
        else
          top = -totalHeight + @parent.offsetHeight
          if parentIsPositioned
            top -= topBorder
        top += @parent.offsetTop unless parentIsPositioned
        @mergeStyle.top = top + "px"

        asLeft = true
        left = 0
        if @cAnchor[1] == "e"
          asLeft = parentPos.right - width > 0
          left += @parent.offsetWidth - width
        else
          asLeft = parentPos.left + width <= windowSize.width
        unless asLeft
          left -= width - @parent.clientWidth

        if asLeft and @cAnchor[1] == "w"
          left += @offset
        else
          left -= @offset

        if asLeft
          if parentIsPositioned
            left -= parseInt(parentStyle.getPropertyValue("border-left-width").replace("px",""))
        else
          unless parentIsPositioned
            left += parseInt(parentStyle.getPropertyValue("border-left-width").replace("px",""))
          left += parseInt(parentStyle.getPropertyValue("border-right-width").replace("px",""))

        left += @parent.offsetLeft unless parentIsPositioned
        @mergeStyle.left = left + "px"

        unless @notDismissable
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

    close: (e) ->
      if e?
        return if e.defaultPrevented
        e.preventDefault()

      @hide()

    toggle:  ->
      if @opened
        @close()
      else
        @open()

  dettached: ->
    @removeDocumentClickListener?()

</script>

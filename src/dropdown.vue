// out: ..
<template lang="jade">
.vc-dropdown(:style="style" v-if="opened" @click.prevent="onClick" @keyup.esc="close | notPrevented | prevent" v-el:dd)
  slot No content
</template>

<script lang="coffee">
module.exports =

  mixins:[
    require("vue-mixins/getViewportSize")
    require("vue-mixins/onceDocument")
  ]

  filters:
    notPrevented: require("vue-filters/notPrevented")
    prevent: require("vue-filters/prevent")

  props:
    "closeOnClick":
      type: Boolean
      default: true
    "constrainWidth":
      type: Boolean
      default: false
    "overlay":
      type: Boolean
      default: false
    "onClick":
      type: Boolean
      default: true
    "offset":
      type: Number
      default: 0
    "anchor":
      type: String
    "isOpened":
      type:Boolean
      default: false
    "fadeIn":
      type: Function
      default: ({el,cb}) ->
        @style.opacity = 1
        cb()
    "fadeOut":
      type: Function
      default: ({el,cb}) ->
        @style.opacity = 0
        cb()
    "parent":
      type: Object

  data: ->
    active: false
    opened: false
    removeDocumentClickListener: null
    removeParentClickListener: null
    clickInside: false
    removeTimeout: null
    style:
      position: "absolute"
      opacity: 0
      left: undefined
      top: undefined

  watch:
    "isOpened": (val) ->
      if val != @opened
        if val
          @open()
        else
          @close()
    "parent": "setupParent"

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

    setupParent: (parent = @parent) ->
      if @onClick
        @removeParentClickListener?()
        parent.addEventListener "click", @onParentClick
        @removeParentClickListener = ->
          parent.removeEventListener "click", @onParentClick

    show: ->
      return if @opened
      @opened = true
      @isOpened = true
      @$nextTick =>
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

        if @closeOnClick
          @removeDocumentClickListener?()
          @removeDocumentClickListener = @onceDocument "click", (e) =>
            @hide() unless @clickInside
            return !@clickInside #should remove?

        @$emit "beforeOpen"
        @fadeIn el:@$els.dd,cb: =>
          @$emit "opened"

    hide: ->
      return unless @opened
      @removeDocumentClickListener?()
      @removeDocumentClickListener = null
      @$emit "beforeClose"
      @fadeOut el:@$els.dd, cb: =>
        @opened = false
        @isOpened = false
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

  attached: ->
    unless @parent?
      @parent = @$el.parentElement
    else
      @setupParent()

  dettached: ->
    @removeParentClickListener?()
    @removeDocumentClickListener?()

</script>

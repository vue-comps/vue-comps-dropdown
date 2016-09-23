// out: ..
<template lang="pug">
ul(v-bind:style="computedStyle" v-bind:id="id" v-if="opened" @click="onClick" @keyup.esc="close" v-el:dd v-bind:class="computedClass" v-bind:transition="cTransition")
  slot
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
    require("vue-mixins/transition")
  ]


  props:
    id:
      type: String
    class:
      default: -> []
    style:
      default: -> []
    notDismissable:
      type: Boolean
      default: false
    closeOnClick:
      type: Boolean
      default: false
    constrainWidth:
      type: Boolean
      default: false
    noSibling:
      type: Boolean
      default: false
    overlay:
      type: Boolean
      default: false
    offset:
      type: Number
      default: 0
      coerce: Number
    anchor:
      type: String
    onBody:
      type: Boolean
      default: false
    transition:
      type: String
      default: "dropdown"

  data: ->
    removeDocumentClickListener: null
    clickInside: false
    removeTimeout: null
    top: null
    left: null
    width: null


  computed:
    cAnchor: ->
      return @anchor if @anchor
      return "nw" if @overlay
      return "sw"
    mergeStyle: ->
      position: "absolute"
      left: @left + "px"
      top: @top + "px"
      display: "block"
      width: @width + "px"

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
      @clickInside = true
      @removeTimeout?()
      @removeTimeout = setTimeout (=>@clickInside = false),10
      @$once "after-enter", =>
        @removeDocumentClickListener?()
        @removeDocumentClickListener = @onceDocument "click", (e) =>
          if @clickInside  or @notDismissable
            return false
          @hide()
          return true
        @$once "after-leave", =>
          @removeDocumentClickListener?()
          @removeDocumentClickListener = null

    hide: ->
      return unless @opened
      @setClosed()

    open: ->
      @show()

    close: (e) ->
      if e?
        return if e.defaultPrevented
        e.preventDefault()

      @hide()

    toggle: ->
      if @opened
        @close()
      else
        @open()

  ready: ->
    @$on "before-enter", ->
      if @onBody
        document.body.appendChild @$els.dd if @onBody
      else unless @noSibling
        @parent.parentElement.insertBefore(@$els.dd, @parent.nextSibling)

      @$nextTick =>
        if @constrainWidth
          offset = Math.abs(@offset)
          totalWidth = @parent.offsetWidth-offset
          @width = totalWidth
        else
          offset = @offset
          totalWidth = @$els.dd.offsetWidth+offset
          @width = null
        totalHeight = @$els.dd.offsetHeight
        totalHeight += @parent.offsetHeight unless @overlay


        parentPos = @parent.getBoundingClientRect()
        windowSize = @getViewportSize()

        asTop = true
        if (@cAnchor[0] == "n" and @overlay) or (@cAnchor[0] == "s" and not @overlay)
          asTop = parentPos.top + totalHeight < windowSize.height
        else
          asTop = parentPos.bottom - totalHeight < 0

        asLeft = true
        if @cAnchor[1] == "e"
          asLeft = parentPos.right - totalWidth < 0
        else
          asLeft = parentPos.left + totalWidth < windowSize.width

        top = 0
        if asTop
          top += @parent.offsetHeight unless @overlay
        else
          top -= totalHeight - @parent.offsetHeight

        left = 0
        if asLeft
          left += offset
        else
          left -= totalWidth - @parent.offsetWidth

        if @onBody
          body = document.body
          docEl = document.documentElement
          scrollTop = window.pageYOffset || docEl.scrollTop || body.scrollTop
          scrollLeft = window.pageXOffset || docEl.scrollLeft || body.scrollLeft
          top += scrollTop + parentPos.top
          left += scrollLeft + parentPos.left
        else
          parentIsPositioned = @noSibling and  /relative|absolute|fixed/.test(getComputedStyle(@parent).getPropertyValue("position"))
          unless parentIsPositioned
            top += @parent.offsetTop
            left += @parent.offsetLeft

        @top = top
        @left = left


  beforeDestroy: ->
    @removeDocumentClickListener?()
    el = @$els.dd
    if el?.parentNode?
      el.parentNode.removeChild(el)
</script>

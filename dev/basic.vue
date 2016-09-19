<template lang="pug">
.container
  button(style="float:left",v-el:floatleft) Click
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style",v-ref:floatleft)
      li Content
      li Content2
  button(style="float:right",v-el:floatright) Click
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style",v-ref:floatright)
      li Content
      li Content2
  .clear(style="clear:both")
  br
  button(v-el:nw) Anchor: "nw"
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style" anchor="nw",v-ref:nw)
      li Content
      li Content2
  button(v-el:ne) Anchor: "ne"
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style" anchor="ne",v-ref:ne)
      li Content
      li Content2
  button(v-el:sw) Anchor: "sw"
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style" anchor="sw",v-ref:sw)
      li Content
      li Content2
  button(v-el:se) Anchor: "se"
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style" anchor="se",v-ref:se)
      li Content
      li Content2
  button(v-bind:style="buttonStyle",style="top:80px;left:10px",v-el:topleft) Click
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style",v-ref:topleft)
      li Content
      li Content2
  button(v-bind:style="buttonStyle",style="top:80px;left:80px") with custom transition
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style" transition="dropdown2")
      li Content
      li Content2
  button(v-bind:style="buttonStyle",style="top:80px;right:10px",v-el:topright) Click
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style",v-ref:topright)
      li Content
      li Content2
  button(v-bind:style="buttonStyle",style="bottom:10px;left:10px",v-el:bottomleft) Click
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style",v-ref:bottomleft)
      li Content
      li Content2
  button(v-bind:style="buttonStyle",style="bottom:10px;right:10px",v-el:bottomright) Click
    dropdown(v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style",v-ref:bottomright)
      li Content
      li Content2
  br
  br
  br
  span dropdown changes anchor automatically to be always in viewport
  br
  span Blue buttons are positioned absolutely
  br
  span change overlay and offset to see different behavior
  br
  toggle(v-bind:is-on.sync="overlay") Overlay prop:
  br
  input(v-model="offset",placeholder="offset in px")
  a(href="https://github.com/vue-comps/vue-comps-dropdown/blob/master/dev/basic.vue" style="position:relative;left:100px") source
</template>

<script lang="coffee">
Velocity = require("velocity-animate")
module.exports =
  components:
    dropdown: require "../src/dropdown.vue"
    toggle: require "vue-toggle"
  data: ->
    offset: null
    overlay: false
    buttonStyle:
      position: "absolute"
      backgroundColor: "#80E0FF"
    style:
      background: "white"
      border: "1px solid black"
      width: "80px"
      margin: 0
      padding: 0
      listStyleType: "none"
      zIndex:1
  transitions:
    dropdown2:
      css: false
      enter: (el,done) ->
        Velocity.hook el, "scale", "0.4"
        Velocity.hook el, "translateY", "-100%"
        Velocity el, {opacity: 1,scale: 1,translateY: 0}, {
          duration: 1000
          queue: false
          complete: done
        }
      enterCancelled: (el) ->
        Velocity el, "stop"
      leave: (el,done) ->
        Velocity el, {opacity: 0,scale:0.4,translateY:"-100%"}, {
          duration: 1000
          queue: false
          complete: done
        }
      leaveCancelled: (el) ->
        Velocity el, "stop"

</script>

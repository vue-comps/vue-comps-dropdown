<template lang="pug">
.container(style="overflow-y:scroll;height:200px")
  br
  br
  br
  button Anchor: "nw"
    dropdown(on-body v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style" anchor="nw")
      li Content
      li Content2
  button Anchor: "ne"
    dropdown(on-body v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style" anchor="ne")
      li Content
      li Content2
  button Anchor: "sw"
    dropdown(on-body v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style" anchor="sw")
      li Content
      li Content2
  button Anchor: "se"
    dropdown(on-body v-bind:overlay="overlay" v-bind:offset="offset" v-bind:style="style" anchor="se")
      li Content
      li Content2
  br
  br
  span scroll container with an open dropdown to see problem of body positioning
  br
  br
  toggle(v-bind:is-on.sync="overlay") Overlay prop:
  br
  input(v-model="offset",placeholder="offset in px")
  a(href="https://github.com/vue-comps/vue-comps-dropdown/blob/master/dev/basic.vue" style="position:relative;left:100px") source
  div(style="height:2000px")
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
    style:
      background: "white"
      border: "1px solid black"
      width: "80px"
      margin: 0
      padding: 0
      listStyleType: "none"
      zIndex:1

</script>

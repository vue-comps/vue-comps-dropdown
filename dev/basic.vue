<template lang="jade">
.container
  button Click
    dropdown
      p Content
  button Click
    dropdown
      p Content
  button Click
    dropdown
      p Content
  button Click
    dropdown
      p Content
  a(href="https://github.com/vue-comps/vue-comps-dropdown/blob/master/dev/basic.vue") source
</template>

<script lang="coffee">
module.exports =
  components:
    "dropdown" : require "../src/dropdown.vue"

</script>

<style lang="stylus">
.container > a
  position absolute
  left 250px
  top 40px
button
  position absolute
  &:nth-child(1)
    top 10px
    left 10px
  &:nth-child(2)
    top 10px
    right 10px
  &:nth-child(3)
    bottom 10px
    left 10px
  &:nth-child(4)
    bottom 10px
    right 10px
.vc-dropdown
  background white
  border 1px solid black
  width 80px
</style>

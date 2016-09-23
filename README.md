# vue-comps-dropdown

a advanced dropdown/up/left/right menu.

### [Demo](https://vue-comps.github.io/vue-comps-dropdown)

# Install

```sh
npm install --save-dev vue-comps-dropdown
```
or include `build/bundle.js`.

## Usage
```coffee
# in your component
components:
  "dropdown": require("vue-comps-dropdown")
# or, when using bundle.js
components:
  "dropdown": window.vueComps.dropdown
```
```html
<button> Open Dropdown
  <dropdown>
    <li>Content</li>
  </dropdown>
</button>
```
altough the `dropdown` is defined within the `button`, it will be positioned as a sibling of the `parent`.


see [`dev/`](https://github.com/vue-comps/vue-comps-dropdown/tree/master/dev) for examples.

#### Props
Name | type | default | description
---:| --- | ---| ---
offset | Number | 0 | horizontal offset
anchor | String | overlay ? "nw" : "sw" | point of the parent where it will be attached
not-dismissable| Boolean | false | will be not close on click outside of dropdown
close-on-click | Boolean | false | will be closed also on click inside of dropdown
constrain-width | Boolean | false | width as parent width
overlay | Boolean | false | will overlay parent
ignore-parent | Boolean | false | will not set-up click listener on parent
is-opened | Boolean | false | (two-way) set to open / close
transition | String | "dropdown" | name of a vue transition. [Detailed description](#transition)
parent | element | parentElement | where the dropdown should attach as a sibling
no-sibling | Boolean | false | position as child instead of sibling of `parent`
on-body | Boolean | false | will be positioned on body instead of parent element. [Detailed description](#positioning)

#### Events
Name |  description
---:| ---
before-enter | will be called before open animation
after-enter |  will be called when opened
before-leave |  will be called before close animation
after-leave |  will be called when closed
toggled(isOpened:Boolean) | emitted when gets opened or closed. Alternative to use two-way `is-opened` prop

#### Positioning
There are three ways of positioning. The default is as a sibling of the parent element, the other posibilities are  as a child of the parent element, or on `body`.
- The sibling/parent positioning can be problematic when you have an `overflow:hidden` as a parent to the nearest element with `position:absolute|relative|fixed` and the dropdown is overflowing.
- the `body` positioning can be problematic when the parent is moving relative to `body` or when you depend on inheritance of styles.

#### Transition

You can provide a vue transition like this:
```js
Vue.transition("fade",{
  // your transition
})
// or in the instance:
transitions: {
  fade: {
    // your transition
  }
}
// usage:
template: "<dropdown transition='fade'></dropdown>"
```

You can access several properties in your enter hook:
```js
enter: function(el,cb) {
  // style properties as numbers
  this.top
  this.left
}
```

## Changelog
- 1.3.1  
fixed constrain-width  
making not-dismissable dynamic  

- 1.3.0  
added toggled event  
set default transition  

- 1.2.1  
added `on-body` prop  

- 1.2.0  
now using vue transitions  
events are renamed after vue transitions  

- 1.1.1  
added `no-sibling` prop to disable positioning as sibling of `parent`

- 1.1.0  
dropdown will be positioned as a sibling of `parent`

# Development
Clone repository.
```sh
npm install
npm run dev
```
Browse to `http://localhost:8080/`.

## License
Copyright (c) 2016 Paul Pflugradt
Licensed under the MIT license.

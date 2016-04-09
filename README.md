# vue-comps-dropdown

a advanced dropdown/up/left/right menu

### [See it in action](https://vue-comps.github.io/vue-comps-dropdown)

# Install

```sh
npm install --save-dev vue-comps-dropdown
```
or include `build/bundle.js`

## Usage
```coffee
# in your component
components:
  "dropdown": require("vue-comps-dropdown")
# or, when using bundle.js
components:
  "dropdown": window.vueComps.dropdown
```

see `dev/` for examples

#### Props
| Name | type | default | description |
| ---:| --- | ---| --- |
| offset | Number | 0 | horizontal offset |
| anchor | String | overlay ? "nw" : "sw" | point of the parent where it will be attached |
| class | String | dropdown-content | class of the `ul`|
| not-dissmissible| Boolean | false | will be not close on click outside of dropdown|
| not-close-on-click | Boolean | false | will not be closed on click inside of dropdown |
| constrain-width | Boolean | false | width as parent width |
| overlay | Boolean | false | will overlay parent |
| ignore-parent | Boolean | false | will not set-up click listener on parent |
| is-opened | Boolean | false | (two-way) set to open / close |
| transition-in | function | no animation | set animation with opacity = 1. Argument: {el,cb} |
| transition-out | function | no animation | set animation with opacity = 0. Argument: {el,cb} |
| parent | element | parentElement | where the dropdown should attach |

#### Events
| Name |  description |
| ---:| --- |
| close |  when received, will close |
| before-open | will be called before open animation |
| opened |  will be called when opened |
| before-close |  will be called before close animation |
| closed |  will be called when closed |



# Development
Clone repository
```sh
npm install
npm run dev
```
Browse to `http://localhost:8080/`

## License
Copyright (c) 2016 Paul Pflugradt
Licensed under the MIT license.

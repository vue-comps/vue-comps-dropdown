env = null
chai.config.includeStack = true

clickNWait = (el,cb) ->
  e = new MouseEvent("click",{
    "view": window,
    "bubbles": true,
    "cancelable": true
  })
  el.dispatchEvent(e)
  env.$nextTick -> env.$nextTick -> env.$nextTick -> cb()

roundBox = (box) ->
  left: Math.round(box.left)
  right: Math.round(box.right)
  top: Math.round(box.top)
  bottom: Math.round(box.bottom)
  width: Math.round(box.width)
  height: Math.round(box.height)

getBoundingBoxes = (name,cb) ->
  btn = env.$els[name]
  clickNWait btn, ->
    dd = env.$refs[name]
    dd.isOpened.should.be.true
    box1 = btn.getBoundingClientRect()
    box2 = dd.$els.dd.getBoundingClientRect()
    clickNWait btn, ->
      dd.isOpened.should.be.false
      should.not.exist dd.$els.dd
      cb(roundBox(box1),roundBox(box2))
startCond = (obj) ->
  obj ?= {}
  obj.offset ?= 0
  env.overlay = obj.overlay
  env.offset = obj.offset
describe "dropdown", ->

  describe "basic env", ->

    before (done) ->
      env = loadComp(require("../dev/basic.vue"))
      env.$nextTick done

    after ->
      #unloadComp(env)

    describe "floating", ->
      it "should work for left", (done) ->
        startCond()
        getBoundingBoxes "floatleft", (box1,box2) ->
          box2.left.should.equal box1.left, "floatleft-left"
          box2.top.should.equal box1.bottom, "floatleft-top"
          done()
      it "should work for right", (done) ->
        startCond()
        getBoundingBoxes "floatright", (box1,box2) ->
          box2.right.should.equal box1.right, "floatright-right"
          box2.top.should.equal box1.bottom, "floatright-top"
          done()
      it "should work with overlay", (done) ->
        startCond(overlay:true)
        getBoundingBoxes "floatleft", (box1,box2) ->
          box2.left.should.equal box1.left, "floatleft-left"
          box2.top.should.equal box1.top, "floatleft-top"
          getBoundingBoxes "floatright", (box1,box2) ->
            box2.right.should.equal box1.right, "floatright-right"
            box2.top.should.equal box1.top, "floatright-top"
            done()
      it "should work with offset", (done) ->
        startCond(offset:20)
        getBoundingBoxes "floatleft", (box1,box2) ->
          box2.left.should.equal box1.left+env.offset, "floatleft-left"
          box2.top.should.equal box1.bottom, "floatleft-top"
          getBoundingBoxes "floatright", (box1,box2) ->
            box2.right.should.equal box1.right-env.offset, "floatright-right"
            box2.top.should.equal box1.bottom, "floatright-top"
            done()
      it "should work with overlay and offset", (done) ->
        startCond(offset:20,overlay:true)
        getBoundingBoxes "floatleft", (box1,box2) ->
          box2.left.should.equal box1.left+env.offset, "floatleft-left"
          box2.top.should.equal box1.top, "floatleft-top"
          getBoundingBoxes "floatright", (box1,box2) ->
            box2.right.should.equal box1.right-env.offset, "floatright-right"
            box2.top.should.equal box1.top, "floatright-top"
            done()

    describe "anchor", ->
      it "should work for all anchors", (done) ->
        startCond()
        getBoundingBoxes "nw", (box1,box2) ->
          box2.left.should.equal box1.left, "nw-left"
          box2.bottom.should.equal box1.top, "nw-bottom"
          getBoundingBoxes "ne", (box1,box2) ->
            box2.right.should.equal box1.right, "ne-right"
            box2.bottom.should.equal box1.top, "ne-bottom"
            getBoundingBoxes "sw", (box1,box2) ->
              box2.left.should.equal box1.left, "sw-left"
              box2.top.should.equal box1.bottom, "sw-top"
              getBoundingBoxes "se", (box1,box2) ->
                box2.right.should.equal box1.right, "se-right"
                box2.top.should.equal box1.bottom, "se-top"
                done()
      it "should work with overlay", (done) ->
        startCond(overlay:true)
        getBoundingBoxes "nw", (box1,box2) ->
          box2.left.should.equal box1.left, "nw-left"
          box2.top.should.equal box1.top, "nw-top"
          getBoundingBoxes "ne", (box1,box2) ->
            box2.right.should.equal box1.right, "ne-right"
            box2.top.should.equal box1.top, "ne-top"
            getBoundingBoxes "sw", (box1,box2) ->
              box2.left.should.equal box1.left, "sw-left"
              box2.bottom.should.equal box1.bottom, "sw-bottom"
              getBoundingBoxes "se", (box1,box2) ->
                box2.right.should.equal box1.right, "se-right"
                box2.bottom.should.equal box1.bottom, "se-bottom"
                done()
      it "should work with offset", (done) ->
        startCond(offset:20)
        getBoundingBoxes "nw", (box1,box2) ->
          box2.left.should.equal box1.left+env.offset, "nw-left"
          box2.bottom.should.equal box1.top, "nw-bottom"
          getBoundingBoxes "ne", (box1,box2) ->
            box2.right.should.equal box1.right-env.offset, "ne-right"
            box2.bottom.should.equal box1.top, "ne-bottom"
            getBoundingBoxes "sw", (box1,box2) ->
              box2.left.should.equal box1.left+env.offset, "sw-left"
              box2.top.should.equal box1.bottom, "sw-top"
              getBoundingBoxes "se", (box1,box2) ->
                box2.right.should.equal box1.right-env.offset, "se-right"
                box2.top.should.equal box1.bottom, "se-top"
                done()
      it "should work with overlay and offset", (done) ->
        startCond(offset:20,overlay:true)
        getBoundingBoxes "nw", (box1,box2) ->
          box2.left.should.equal box1.left+env.offset, "nw-left"
          box2.top.should.equal box1.top, "nw-top"
          getBoundingBoxes "ne", (box1,box2) ->
            box2.right.should.equal box1.right-env.offset, "ne-right"
            box2.top.should.equal box1.top, "ne-top"
            getBoundingBoxes "sw", (box1,box2) ->
              box2.left.should.equal box1.left+env.offset, "sw-left"
              box2.bottom.should.equal box1.bottom, "sw-bottom"
              getBoundingBoxes "se", (box1,box2) ->
                box2.right.should.equal box1.right-env.offset, "se-right"
                box2.bottom.should.equal box1.bottom, "se-bottom"
                done()

    describe "absolute positioned", ->
      it "should work for all", (done) ->
        startCond()
        getBoundingBoxes "topleft", (box1,box2) ->
          box2.left.should.equal box1.left, "topleft-left"
          box2.top.should.equal box1.bottom, "topleft-top"
          getBoundingBoxes "topright", (box1,box2) ->
            box2.right.should.equal box1.right, "topright-right"
            box2.top.should.equal box1.bottom, "topright-top"
            getBoundingBoxes "bottomleft", (box1,box2) ->
              box2.left.should.equal box1.left, "bottomleft-left"
              box2.bottom.should.equal box1.top, "bottomleft-bottom"
              getBoundingBoxes "bottomright", (box1,box2) ->
                box2.right.should.equal box1.right, "bottomright-right"
                box2.bottom.should.equal box1.top, "bottomright-bottom"
                done()
      it "should work with overlay", (done) ->
        startCond(overlay:true)
        getBoundingBoxes "topleft", (box1,box2) ->
          box2.left.should.equal box1.left, "topleft-left"
          box2.top.should.equal box1.top, "topleft-top"
          getBoundingBoxes "topright", (box1,box2) ->
            box2.right.should.equal box1.right, "topright-right"
            box2.top.should.equal box1.top, "topright-top"
            getBoundingBoxes "bottomleft", (box1,box2) ->
              box2.left.should.equal box1.left, "bottomleft-left"
              box2.bottom.should.equal box1.bottom, "bottomleft-bottom"
              getBoundingBoxes "bottomright", (box1,box2) ->
                box2.right.should.equal box1.right, "bottomright-right"
                box2.bottom.should.equal box1.bottom, "bottomright-bottom"
                done()
      it "should work with offset", (done) ->
        startCond(offset:20)
        getBoundingBoxes "topleft", (box1,box2) ->
          box2.left.should.equal box1.left+env.offset, "topleft-left"
          box2.top.should.equal box1.bottom, "topleft-top"
          getBoundingBoxes "topright", (box1,box2) ->
            box2.right.should.equal box1.right-env.offset, "topright-right"
            box2.top.should.equal box1.bottom, "topright-top"
            getBoundingBoxes "bottomleft", (box1,box2) ->
              box2.left.should.equal box1.left+env.offset, "bottomleft-left"
              box2.bottom.should.equal box1.top, "bottomleft-bottom"
              getBoundingBoxes "bottomright", (box1,box2) ->
                box2.right.should.equal box1.right-env.offset, "bottomright-right"
                box2.bottom.should.equal box1.top, "bottomright-bottom"
                done()
      it "should work with both", (done) ->
        startCond(overlay:true,offset:20)
        getBoundingBoxes "topleft", (box1,box2) ->
          box2.left.should.equal box1.left+env.offset, "topleft-left"
          box2.top.should.equal box1.top, "topleft-top"
          getBoundingBoxes "topright", (box1,box2) ->
            box2.right.should.equal box1.right-env.offset, "topright-right"
            box2.top.should.equal box1.top, "topright-top"
            getBoundingBoxes "bottomleft", (box1,box2) ->
              box2.left.should.equal box1.left+env.offset, "bottomleft-left"
              box2.bottom.should.equal box1.bottom, "bottomleft-bottom"
              getBoundingBoxes "bottomright", (box1,box2) ->
                box2.right.should.equal box1.right-env.offset, "bottomright-right"
                box2.bottom.should.equal box1.bottom, "bottomright-bottom"
                done()

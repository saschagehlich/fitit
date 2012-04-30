LevelGenerator = require "./lib/levelgenerator"


start = +new Date()
generator = new LevelGenerator
level = generator.getRandomLevel()
end = +new Date()

levelData = level.data
blocks = level.blocks

util = require "util"

util.print "|-"
for i in [0...levelData[0].length]
  util.print "--"
util.print "-|\n"

for i in [0...levelData.length]
  util.print "| "
  for j in [0...levelData[i].length]
    tile = levelData[i][j]
    switch tile
      when -1
        util.print "  "
      else
        util.print "#{tile} "
  util.print " |\n"

util.print "|-"
for i in [0...levelData[0].length]
  util.print "--"
util.print "-|\n"

console.log "Generation took #{end-start}ms"
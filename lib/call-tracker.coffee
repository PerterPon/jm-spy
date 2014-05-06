
# /*
#   CallTracker
#   Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
#   Create: Sat Apr 19 2014 17:31:41 GMT+0800 (CST)
# */
#

"use strict"

class CallTracker

  constructor : () ->
    @calls = []

  track : ( context ) ->
    @calls.push context

  any : ->
    !!@calls.length

  count : ->
    @calls.length

  argsFor : ( index ) ->
    call = @calls[ index ]
    call?.args ? []

  all : ->
    @calls

  allArgs : ->
    allArgs = []
    for call in @calls
      allArgs.push call.args
    allArgs

  first : ->
    @calls[ 0 ]

  mostRecent : ->
    @calls[ @calls.length - 1 ]

  reset : ->
    @calls = []

exports = module.exports = CallTracker

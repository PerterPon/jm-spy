if (require.extensions['.coffee']) {
  module.exports = require('./lib/jmspy.coffee');
} else {
  module.exports = require('./out/release/lib/jmspy.js');
}

const {merge} = require('webpack-merge');
const client = require('./client.js');
const path = require('path');

module.exports = merge(client, {
  mode: 'development',
  devServer: {
    inline: true,
    publicPath: '/static',
    contentBase: path.resolve('public'),
    openPage: 'index.html',
    port: 3000,
  },
})

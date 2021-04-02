const path = require('path');
const nodeExternals = require('webpack-node-externals');

module.exports = {
  mode: 'production',
  entry: {
    'server': './server',
  },
  target: 'node',
  externals: [nodeExternals()],
  output: {
    path: path.join(__dirname, '..', 'build'),
    filename: '[name].js',
  },
  module: {
    rules: [{
      test: /\.ts$/,
      loader: 'ts-loader',
      options: {configFile: 'tsconfig.json'},
    }],
  },
  resolve: {
    extensions: ['.ts'],
  },
};

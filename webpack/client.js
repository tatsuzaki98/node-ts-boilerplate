const path = require('path');

module.exports = {
  mode: 'production',
  entry: {
    'client': './client',
  },
  output: {
    path: path.resolve(`build/static`),
    filename: '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        loader: 'ts-loader',
        options: {configFile: 'tsconfig.json'},
      },
    ],
  },
  resolve: {
    modules: ['node_modules'],
    extensions: ['.ts', '.js'],
  },
};

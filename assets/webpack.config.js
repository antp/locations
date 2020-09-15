const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');


const PurgecssPlugin = require('purgecss-webpack-plugin');
// const globAll = require('glob-all');

// Custom PurgeCSS extractor for Tailwind that allows special characters in
// class names.
// Regex explanation: https://tailwindcss.com/docs/controlling-file-size/#understanding-the-regex
const TailwindExtractor = content => {
  return content.match(/[\w-/:\.]+(?<!:)/g) || [];
};

module.exports = (env, options) => {
  const devMode = options.mode !== 'production';

  return {
    optimization: {
      minimizer: [
        new TerserPlugin({ cache: true, parallel: true, sourceMap: devMode }),
        new OptimizeCSSAssetsPlugin({}),
        new PurgecssPlugin({
          paths: glob.sync('../lib/Locations_web/live/**/*.ex')
            .concat('../lib/Locations_web/templates/**/*.html.eex')
            .concat('../lib/Locations_web/views/**/*.ex')
            .concat('../assets/js/**/*.js')
          ,
          extractors: [
            {
              extractor: TailwindExtractor,
              extensions: ['html', 'js', 'eex', 'leex', 'ex'],
            },
          ],
        }),
      ]
    },
    entry: {
      'app': glob.sync('./vendor/**/*.js').concat(['./js/app.js'])
    },
    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, '../priv/static/js'),
      publicPath: '/js/'
    },
    devtool: devMode ? 'source-map' : undefined,
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader'
          }
        },
        {
          test: /\.[s]?css$/,
          use: [
            MiniCssExtractPlugin.loader,
            'css-loader',
            'postcss-loader',
            'sass-loader',
          ],
        }
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: '../css/app.css' }),
      new CopyWebpackPlugin([{ from: 'static/', to: '../' }])
    ]
  }
};

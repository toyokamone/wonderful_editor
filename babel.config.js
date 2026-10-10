module.exports = function (api) {
  api.cache(true)

  return {
    presets: [
      [
        '@babel/preset-env',
        {
          modules: false,
          targets: {
            browsers: '> 1%, last 2 versions, not ie <= 8'
          }
        }
      ]
    ],
    plugins: [
      '@babel/plugin-syntax-dynamic-import',
      '@babel/plugin-transform-destructuring',
      ['@babel/plugin-proposal-class-properties', { loose: true }],
      ['@babel/plugin-proposal-object-rest-spread', { useBuiltIns: true }],
      ['@babel/plugin-transform-runtime', { helpers: false }],
      ['@babel/plugin-transform-regenerator', { async: false }]
    ]
  }
}

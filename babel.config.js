module.exports = function (api) {
  api.cache(true)

  return {
    presets: [
      [
        '@babel/preset-env',
        {
          modules: false
        }
      ]
    ],
    plugins: [
      // エラー回避のため空のプラグインとして定義
    ]
  }
}

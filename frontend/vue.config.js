module.exports = {
	lintOnSave: false,
    devServer: {
        proxy: {  //配置跨域
            '/api': {
                target: 'http://127.0.0.1:5000',
                ws: true,
                changOrigin: true,  //允许跨域
                pathRewrite: {
                    '^/api': '/'  //请求的时候使用这个api就可以
                }
            }
        }
    }
}

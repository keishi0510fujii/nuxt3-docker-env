// https://v3.nuxtjs.org/api/configuration/nuxt.config
export default defineNuxtConfig({
	vite: {
		server: {
			watch: {
					//	TODO: きちんと設定して、ts-ignoreを削除する
					// @ts-ignore
					usePolling: true,
				},
		},
	},
})

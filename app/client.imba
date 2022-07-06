global css html
	ff:sans

import './Player'

tag app
	def render
		<self>
			<header>
				<svg[w:200px h:auto] src='./logo.svg'>
				<p> "Edit {<code> "app/client.imba"} and save to reload"
				<a href="https://imba.io"> "Learn Imba"
			<player[mt:32px]>

imba.mount <app>

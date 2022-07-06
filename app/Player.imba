import "regenerator-runtime/runtime"
import audio from './audio.8341.mp3'
import { Howl, Howler } from 'howler'
import Sound from './Sound'
import { unstable_getHowlInternals } from './utils';

import createSoundTouchNode from "./soundtouchjs/createSoundTouchNode"
const script = import.worker('./soundtouchjs/SoundTouchWorklet')

const audioContext = new window.AudioContext();
audioContext.audioWorklet.addModule(script.url).catch(console.log);


let state = {
	pitch: 0,
}

let playing = false 

tag player
	sound
	soundTouchNode

	def mount
		load!
		$interval = setInterval(render.bind(self),1000)

	def unmount
		clearInterval($interval)


	def load
		if sound && sound.state() !== 'unloaded'
			stop()
			# unload()


		sound = await loadSound(audio);
		sound.on('end', this.handleOnEnd);


		
		# const unstable_soundInternals = unstable_getHowlInternals(sound)
		# let source = audioContext.createMediaElementSource(unstable_soundInternals.node);
		# source.connect(audioContext.destination);
		# log source, unstable_soundInternals
		# return new AudioWorkletNode(audioContext, "soundtouch-worklet");


		let request = new XMLHttpRequest();
		request.open('GET', audio, true);
		request.responseType = 'arraybuffer';

		request.onload = do()
			console.log('audio loaded');

			const SoundTouchNode = createSoundTouchNode(audioContext, window.AudioWorkletNode, request.response);
			SoundTouchNode.on('initialized', do()
				self.soundTouchNode = SoundTouchNode;
				console.log('isFinite')
			);
			SoundTouchNode.on('play', do(details) console.log(details))

		console.log('reading audio');
		request.send();




	def handleOnEnd
		stop()
		playing = false


	def loadSound blobUrl
		return new Promise(do(resolve, reject)
			const newSound = new Sound({
				src: blobUrl,
				format: ['mp3'],
				html5: true,
				onload: do()
					resolve(this)
				onloaderror: do(_, e)
					reject(e);
			});
		)

	def play
		sound.play();
		soundTouchNode.connectToBuffer();
		soundTouchNode.connect(audioContext.destination);
		soundTouchNode.play()
		log sound
		playing = true

	def stop
		sound.stop();
		playing = false

	def pause
		sound.pause();
		soundTouchNode.pause()
		playing = false

	def seek elapsed
		sound.seek(elapsed);

	def rewind
		seek(0);

	def progress
		if sound
			return sound.getElapsed()
		return 0

	def duration
		unless sound
			return 0
		const unstable_soundInternals = unstable_getHowlInternals(sound)
		return unstable_soundInternals.node.duration

	def clickSeek event
		seek(event.target.value)

	def render
		<self>
			<h1> 'Player', state.progress
			if playing
				<button @click=pause> 'Pause'
			else
				<button @click=play> 'Play'
			<input type="range" min=0 max=duration() value=progress() @input=clickSeek>
			<h4> 'Pitch'
			<input type="range" min=-6 max=6 bind=state.pitch>

	css
		input
			w:100%

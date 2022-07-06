import "regenerator-runtime/runtime"
import { Howl } from "howler"
# import worklet from "./soundtouchjs/SoundTouchWorklet"
import { isHowl, unstable_getHowlInternals } from "./utils"

export default class Sound < Howl
	timeElapsed = 0

	startTime\number

	def updateElapsed
		if this.startTime
			this.timeElapsed += window.performance.now() - this.startTime
			this.startTime = undefined

	def play
		this.startTime = window.performance.now()

		return super.play()

	def stop
		this.updateElapsed()

		return super.stop()

	def pause
		this.updateElapsed()

		return super.pause()

	def getTimePlayed
		return this.timeElapsed

	def reset
		this.timeElapsed = 0
		this.startTime = undefined

	def getElapsed
		let value = this.seek()

		# HACK: use this because howler don't return real number in Howl.seek() when Howl is paused
		if isHowl(value)
			value = unstable_getHowlInternals(this)?.seek

		return value || undefined

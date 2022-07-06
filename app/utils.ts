import type { Howl } from 'howler';

export function isHowl(val: any): val is Howl {
  return typeof val === 'object' && 'play' in val && 'pannerAttr' in val;
}

export const unstable_getHowlInternals = (howl: Howl) => {
  const rawSound = (howl as any)._sounds[0];

  if (!rawSound) return;

  return {
    node: rawSound._node as HTMLMediaElement,
    seek: rawSound._seek as number,
  };
};

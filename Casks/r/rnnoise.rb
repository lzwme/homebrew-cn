cask "rnnoise" do
  version "1.03"
  sha256 "544d1daef1c32e2e5bbb2f43eda1c5f2619f2a9e755721ee26366b5eda9e2668"

  url "https:github.comwermannoise-suppression-for-voicereleasesdownloadv#{version}macos-rnnoise.zip"
  name "Noise Suppression for Voice"
  desc "Real-time Noise Suppression Plugin"
  homepage "https:github.comwermannoise-suppression-for-voice"

  audio_unit_plugin "macos-rnnoisernnoise.component"
  vst_plugin "macos-rnnoisevstrnnoise_mono.vst"
  vst_plugin "macos-rnnoisevstrnnoise_stereo.vst"
  vst3_plugin "macos-rnnoisernnoise.vst3"
end
cask "rnnoise" do
  version "1.10"
  sha256 "53c41fe3ce8af529b1d2d18802ecbd7e9f0b6d7ad013fd5f92f6af974472a9e9"

  url "https:github.comwermannoise-suppression-for-voicereleasesdownloadv#{version}macos-rnnoise.zip"
  name "Noise Suppression for Voice"
  desc "Real-time Noise Suppression Plugin"
  homepage "https:github.comwermannoise-suppression-for-voice"

  no_autobump! because: :requires_manual_review

  audio_unit_plugin "macos-rnnoisernnoise.component"
  vst_plugin "macos-rnnoisevstrnnoise_mono.vst"
  vst_plugin "macos-rnnoisevstrnnoise_stereo.vst"
  vst3_plugin "macos-rnnoisernnoise.vst3"

  zap rmdir: [
    "~LibraryAudioPlug-InsVST",
    "~LibraryAudioPlug-InsVST3",
  ]
end
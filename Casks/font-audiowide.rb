cask "font-audiowide" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaudiowideAudiowide-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Audiowide"
  homepage "https:fonts.google.comspecimenAudiowide"

  font "Audiowide-Regular.ttf"

  # No zap stanza required
end
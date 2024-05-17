cask "font-whisper" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflwhisperWhisper-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Whisper"
  homepage "https:fonts.google.comspecimenWhisper"

  font "Whisper-Regular.ttf"

  # No zap stanza required
end
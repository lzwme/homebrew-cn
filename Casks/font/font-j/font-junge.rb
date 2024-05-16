cask "font-junge" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljungeJunge-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Junge"
  homepage "https:fonts.google.comspecimenJunge"

  font "Junge-Regular.ttf"

  # No zap stanza required
end
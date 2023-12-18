cask "font-handlee" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhandleeHandlee-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Handlee"
  homepage "https:fonts.google.comspecimenHandlee"

  font "Handlee-Regular.ttf"

  # No zap stanza required
end
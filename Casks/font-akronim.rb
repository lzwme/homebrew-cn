cask "font-akronim" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflakronimAkronim-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Akronim"
  homepage "https:fonts.google.comspecimenAkronim"

  font "Akronim-Regular.ttf"

  # No zap stanza required
end
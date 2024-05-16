cask "font-alike" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflalikeAlike-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Alike"
  homepage "https:fonts.google.comspecimenAlike"

  font "Alike-Regular.ttf"

  # No zap stanza required
end
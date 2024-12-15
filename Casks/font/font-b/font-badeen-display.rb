cask "font-badeen-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbadeendisplayBadeenDisplay-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Badeen Display"
  homepage "https:fonts.google.comspecimenBadeen+Display"

  font "BadeenDisplay-Regular.ttf"

  # No zap stanza required
end
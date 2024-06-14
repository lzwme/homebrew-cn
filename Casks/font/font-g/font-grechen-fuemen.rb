cask "font-grechen-fuemen" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgrechenfuemenGrechenFuemen-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Grechen Fuemen"
  homepage "https:fonts.google.comspecimenGrechen+Fuemen"

  font "GrechenFuemen-Regular.ttf"

  # No zap stanza required
end
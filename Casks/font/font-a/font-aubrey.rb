cask "font-aubrey" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaubreyAubrey-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Aubrey"
  homepage "https:fonts.google.comspecimenAubrey"

  font "Aubrey-Regular.ttf"

  # No zap stanza required
end
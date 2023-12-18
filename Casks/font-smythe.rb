cask "font-smythe" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsmytheSmythe-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Smythe"
  homepage "https:fonts.google.comspecimenSmythe"

  font "Smythe-Regular.ttf"

  # No zap stanza required
end
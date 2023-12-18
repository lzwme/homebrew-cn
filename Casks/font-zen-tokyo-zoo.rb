cask "font-zen-tokyo-zoo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflzentokyozooZenTokyoZoo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Zen Tokyo Zoo"
  homepage "https:fonts.google.comspecimenZen+Tokyo+Zoo"

  font "ZenTokyoZoo-Regular.ttf"

  # No zap stanza required
end
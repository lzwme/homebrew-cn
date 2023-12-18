cask "font-myanmar-sans-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmyanmarsansproMyanmarSansPro-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Myanmar Sans Pro"
  homepage "https:fonts.google.comearlyaccess"

  font "MyanmarSansPro-Regular.ttf"

  # No zap stanza required
end
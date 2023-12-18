cask "font-tharlon" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltharlonTharlon-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Tharlon"
  homepage "https:fonts.google.comearlyaccess"

  font "Tharlon-Regular.ttf"

  # No zap stanza required
end
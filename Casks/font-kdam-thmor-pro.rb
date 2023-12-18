cask "font-kdam-thmor-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkdamthmorproKdamThmorPro-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kdam Thmor Pro"
  desc "Used as the latin counterpart in the project"
  homepage "https:fonts.google.comspecimenKdam+Thmor+Pro"

  font "KdamThmorPro-Regular.ttf"

  # No zap stanza required
end
cask "font-architects-daughter" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflarchitectsdaughterArchitectsDaughter-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Architects Daughter"
  homepage "https:fonts.google.comspecimenArchitects+Daughter"

  font "ArchitectsDaughter-Regular.ttf"

  # No zap stanza required
end
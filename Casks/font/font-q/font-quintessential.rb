cask "font-quintessential" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflquintessentialQuintessential-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Quintessential"
  homepage "https:fonts.google.comspecimenQuintessential"

  font "Quintessential-Regular.ttf"

  # No zap stanza required
end
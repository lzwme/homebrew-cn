cask "font-inder" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflinderInder-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Inder"
  homepage "https:fonts.google.comspecimenInder"

  font "Inder-Regular.ttf"

  # No zap stanza required
end
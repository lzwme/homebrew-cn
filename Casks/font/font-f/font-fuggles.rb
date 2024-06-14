cask "font-fuggles" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfugglesFuggles-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Fuggles"
  homepage "https:fonts.google.comspecimenFuggles"

  font "Fuggles-Regular.ttf"

  # No zap stanza required
end
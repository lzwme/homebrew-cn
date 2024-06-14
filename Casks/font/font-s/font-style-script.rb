cask "font-style-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflstylescriptStyleScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Style Script"
  homepage "https:fonts.google.comspecimenStyle+Script"

  font "StyleScript-Regular.ttf"

  # No zap stanza required
end
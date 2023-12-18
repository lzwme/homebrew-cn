cask "font-style-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflstylescriptStyleScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Style Script"
  desc "Upright script with looks that vary from casual to formal in appearance"
  homepage "https:fonts.google.comspecimenStyle+Script"

  font "StyleScript-Regular.ttf"

  # No zap stanza required
end
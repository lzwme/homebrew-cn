cask "font-nova-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnovascriptNovaScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Nova Script"
  homepage "https:fonts.google.comspecimenNova+Script"

  font "NovaScript-Regular.ttf"

  # No zap stanza required
end
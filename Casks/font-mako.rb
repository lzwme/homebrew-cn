cask "font-mako" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmakoMako-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mako"
  homepage "https:fonts.google.comspecimenMako"

  font "Mako-Regular.ttf"

  # No zap stanza required
end
cask "font-aclonica" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacheaclonicaAclonica-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Aclonica"
  homepage "https:fonts.google.comspecimenAclonica"

  font "Aclonica-Regular.ttf"

  # No zap stanza required
end
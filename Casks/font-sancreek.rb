cask "font-sancreek" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsancreekSancreek-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sancreek"
  homepage "https:fonts.google.comspecimenSancreek"

  font "Sancreek-Regular.ttf"

  # No zap stanza required
end
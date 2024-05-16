cask "font-iceberg" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflicebergIceberg-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Iceberg"
  homepage "https:fonts.google.comspecimenIceberg"

  font "Iceberg-Regular.ttf"

  # No zap stanza required
end
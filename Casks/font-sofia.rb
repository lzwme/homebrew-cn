cask "font-sofia" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsofiaSofia-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sofia"
  homepage "https:fonts.google.comspecimenSofia"

  font "Sofia-Regular.ttf"

  # No zap stanza required
end
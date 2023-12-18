cask "font-smokum" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachesmokumSmokum-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Smokum"
  homepage "https:fonts.google.comspecimenSmokum"

  font "Smokum-Regular.ttf"

  # No zap stanza required
end
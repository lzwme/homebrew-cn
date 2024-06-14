cask "font-updock" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflupdockUpdock-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Updock"
  homepage "https:fonts.google.comspecimenUpdock"

  font "Updock-Regular.ttf"

  # No zap stanza required
end
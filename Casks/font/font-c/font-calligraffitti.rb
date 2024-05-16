cask "font-calligraffitti" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachecalligraffittiCalligraffitti-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Calligraffitti"
  homepage "https:fonts.google.comspecimenCalligraffitti"

  font "Calligraffitti-Regular.ttf"

  # No zap stanza required
end
cask "font-alkalami" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflalkalamiAlkalami-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Alkalami"
  homepage "https:fonts.google.comspecimenAlkalami"

  font "Alkalami-Regular.ttf"

  # No zap stanza required
end
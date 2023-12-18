cask "font-noto-sans-elymaic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanselymaicNotoSansElymaic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Elymaic"
  homepage "https:fonts.google.comspecimenNoto+Sans+Elymaic"

  font "NotoSansElymaic-Regular.ttf"

  # No zap stanza required
end
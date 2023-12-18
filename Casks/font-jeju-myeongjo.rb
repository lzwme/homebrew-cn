cask "font-jeju-myeongjo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljejumyeongjoJejuMyeongjo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jeju Myeongjo"
  homepage "https:fonts.google.comearlyaccess"

  font "JejuMyeongjo-Regular.ttf"

  # No zap stanza required
end
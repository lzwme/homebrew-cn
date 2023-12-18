cask "font-nanum-myeongjo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnanummyeongjo"
  name "Nanum Myeongjo"
  homepage "https:fonts.google.comspecimenNanum+Myeongjo"

  font "NanumMyeongjo-Bold.ttf"
  font "NanumMyeongjo-ExtraBold.ttf"
  font "NanumMyeongjo-Regular.ttf"

  # No zap stanza required
end
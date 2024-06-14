cask "font-noto-serif-cjk-kr" do
  version "2.002"
  sha256 "4df44fb37250f09d7f0382b70e389c400cbb2f4b783ac65c262e8bfa26c64fc1"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSerif#{version}08_NotoSerifCJKkr.zip"
  name "Noto Serif CJK KR"
  homepage "https:github.comnotofontsnoto-cjktreemainSerif"

  livecheck do
    cask "font-noto-serif-cjk"
  end

  font "OTFKoreanNotoSerifCJKkr-Black.otf"
  font "OTFKoreanNotoSerifCJKkr-Bold.otf"
  font "OTFKoreanNotoSerifCJKkr-ExtraLight.otf"
  font "OTFKoreanNotoSerifCJKkr-Light.otf"
  font "OTFKoreanNotoSerifCJKkr-Medium.otf"
  font "OTFKoreanNotoSerifCJKkr-Regular.otf"
  font "OTFKoreanNotoSerifCJKkr-SemiBold.otf"

  # No zap stanza required
end
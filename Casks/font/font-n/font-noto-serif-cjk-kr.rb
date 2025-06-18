cask "font-noto-serif-cjk-kr" do
  version "2.003"
  sha256 "2132d84616ea55b2b6073bd7b3da5ccd90e59e61fdeab681107d33ab099be367"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSerif#{version}08_NotoSerifCJKkr.zip"
  name "Noto Serif CJK KR"
  homepage "https:github.comnotofontsnoto-cjktreemainSerif"

  livecheck do
    cask "font-noto-serif-cjk"
  end

  no_autobump! because: :requires_manual_review

  font "OTFKoreanNotoSerifCJKkr-Black.otf"
  font "OTFKoreanNotoSerifCJKkr-Bold.otf"
  font "OTFKoreanNotoSerifCJKkr-ExtraLight.otf"
  font "OTFKoreanNotoSerifCJKkr-Light.otf"
  font "OTFKoreanNotoSerifCJKkr-Medium.otf"
  font "OTFKoreanNotoSerifCJKkr-Regular.otf"
  font "OTFKoreanNotoSerifCJKkr-SemiBold.otf"

  # No zap stanza required
end
cask "font-noto-serif-cjk-jp" do
  version "2.003"
  sha256 "d7e956584f1e9417a0a72de22bfc33103d7dea78c9f84e5876920eb35ef40a13"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSerif#{version}07_NotoSerifCJKjp.zip"
  name "Noto Serif CJK JP"
  homepage "https:github.comnotofontsnoto-cjktreemainSerif"

  no_autobump! because: :requires_manual_review

  livecheck do
    cask "font-noto-serif-cjk"
  end

  font "OTFJapaneseNotoSerifCJKjp-Black.otf"
  font "OTFJapaneseNotoSerifCJKjp-Bold.otf"
  font "OTFJapaneseNotoSerifCJKjp-ExtraLight.otf"
  font "OTFJapaneseNotoSerifCJKjp-Light.otf"
  font "OTFJapaneseNotoSerifCJKjp-Medium.otf"
  font "OTFJapaneseNotoSerifCJKjp-Regular.otf"
  font "OTFJapaneseNotoSerifCJKjp-SemiBold.otf"

  # No zap stanza required
end
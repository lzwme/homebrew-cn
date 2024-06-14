cask "font-noto-serif-cjk-tc" do
  version "2.002"
  sha256 "bd14b808431c5058c69f999c3c6d898b9f37d96962ec26f7212fb34c2d49ea5c"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSerif#{version}10_NotoSerifCJKtc.zip"
  name "Noto Serif CJK TC"
  homepage "https:github.comnotofontsnoto-cjktreemainSerif"

  livecheck do
    cask "font-noto-serif-cjk"
  end

  font "OTFTraditionalChineseNotoSerifCJKtc-Black.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-Bold.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-ExtraLight.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-Light.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-Medium.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-Regular.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-SemiBold.otf"

  # No zap stanza required
end
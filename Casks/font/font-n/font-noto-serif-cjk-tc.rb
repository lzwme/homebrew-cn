cask "font-noto-serif-cjk-tc" do
  version "2.003"
  sha256 "b4aa07b217532c5859b3674d53588671e7e4f340054fc30e9bf417ee3b1aa4d4"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSerif#{version}10_NotoSerifCJKtc.zip"
  name "Noto Serif CJK TC"
  homepage "https:github.comnotofontsnoto-cjktreemainSerif"

  livecheck do
    cask "font-noto-serif-cjk"
  end

  no_autobump! because: :requires_manual_review

  font "OTFTraditionalChineseNotoSerifCJKtc-Black.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-Bold.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-ExtraLight.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-Light.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-Medium.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-Regular.otf"
  font "OTFTraditionalChineseNotoSerifCJKtc-SemiBold.otf"

  # No zap stanza required
end
cask "font-noto-serif-cjk-sc" do
  version "2.002"
  sha256 "eeede72f5b88655a3630f18661155028578afc88aa9e67e55db45a8b5be46789"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSerif#{version}09_NotoSerifCJKsc.zip"
  name "Noto Serif CJK SC"
  homepage "https:github.comnotofontsnoto-cjktreemainSerif"

  livecheck do
    cask "font-noto-serif-cjk"
  end

  font "OTFSimplifiedChineseNotoSerifCJKsc-Black.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-Bold.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-ExtraLight.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-Light.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-Medium.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-Regular.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-SemiBold.otf"

  # No zap stanza required
end
cask "font-noto-serif-cjk-sc" do
  version "2.003"
  sha256 "4bcdbff95cedfb6a4c0640403f0de8b69480d869331c24c8eff91f7bb834df04"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSerif#{version}09_NotoSerifCJKsc.zip"
  name "Noto Serif CJK SC"
  homepage "https:github.comnotofontsnoto-cjktreemainSerif"

  livecheck do
    cask "font-noto-serif-cjk"
  end

  no_autobump! because: :requires_manual_review

  font "OTFSimplifiedChineseNotoSerifCJKsc-Black.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-Bold.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-ExtraLight.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-Light.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-Medium.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-Regular.otf"
  font "OTFSimplifiedChineseNotoSerifCJKsc-SemiBold.otf"

  # No zap stanza required
end
cask "font-noto-serif-cjk-hk" do
  version "2.003"
  sha256 "2eaf73871cbc53e72bb1021d760eb64b395955d33fdc560964e15b429a64c288"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSerif#{version}11_NotoSerifCJKhk.zip"
  name "Noto Serif CJK HK"
  homepage "https:github.comnotofontsnoto-cjktreemainSerif"

  livecheck do
    cask "font-noto-serif-cjk"
  end

  no_autobump! because: :requires_manual_review

  font "OTFTraditionalChineseHKNotoSerifCJKhk-Bold.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-Black.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-ExtraLight.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-Light.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-Medium.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-Regular.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-SemiBold.otf"

  # No zap stanza required
end
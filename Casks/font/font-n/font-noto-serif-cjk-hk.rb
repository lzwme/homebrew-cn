cask "font-noto-serif-cjk-hk" do
  version "2.002"
  sha256 "7f02747e29f8aeb1988d3f3a41166bf309d3c1f27ab263d760e48ac9857c37e7"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSerif#{version}11_NotoSerifCJKhk.zip"
  name "Noto Serif CJK HK"
  desc "Language Specific OTFs Traditional Chinese — Hong Kong (繁體中文—香港)"
  homepage "https:github.comnotofontsnoto-cjktreemainSerif"

  livecheck do
    cask "font-noto-serif-cjk"
  end

  font "OTFTraditionalChineseHKNotoSerifCJKhk-Bold.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-Black.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-ExtraLight.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-Light.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-Medium.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-Regular.otf"
  font "OTFTraditionalChineseHKNotoSerifCJKhk-SemiBold.otf"

  # No zap stanza required
end
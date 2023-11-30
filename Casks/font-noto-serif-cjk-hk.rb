cask "font-noto-serif-cjk-hk" do
  version "2.002"
  sha256 "7f02747e29f8aeb1988d3f3a41166bf309d3c1f27ab263d760e48ac9857c37e7"

  url "https://ghproxy.com/https://github.com/notofonts/noto-cjk/releases/download/Serif#{version}/11_NotoSerifCJKhk.zip"
  name "Noto Serif CJK HK"
  desc "Language Specific OTFs Traditional Chinese — Hong Kong (繁體中文—香港)"
  homepage "https://github.com/notofonts/noto-cjk/tree/main/Serif"

  livecheck do
    url :url
    regex(/^Serif(\d+(?:\.\d+)+)$/i)
  end

  font "OTF/TraditionalChineseHK/NotoSerifCJKhk-Bold.otf"
  font "OTF/TraditionalChineseHK/NotoSerifCJKhk-Black.otf"
  font "OTF/TraditionalChineseHK/NotoSerifCJKhk-ExtraLight.otf"
  font "OTF/TraditionalChineseHK/NotoSerifCJKhk-Light.otf"
  font "OTF/TraditionalChineseHK/NotoSerifCJKhk-Medium.otf"
  font "OTF/TraditionalChineseHK/NotoSerifCJKhk-Regular.otf"
  font "OTF/TraditionalChineseHK/NotoSerifCJKhk-SemiBold.otf"

  # No zap stanza required
end
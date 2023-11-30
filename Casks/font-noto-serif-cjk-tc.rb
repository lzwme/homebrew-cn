cask "font-noto-serif-cjk-tc" do
  version "2.002"
  sha256 "bd14b808431c5058c69f999c3c6d898b9f37d96962ec26f7212fb34c2d49ea5c"

  url "https://ghproxy.com/https://github.com/notofonts/noto-cjk/releases/download/Serif#{version}/10_NotoSerifCJKtc.zip"
  name "Noto Serif CJK TC"
  desc "Language Specific OTFs Traditional Chinese — Taiwan (繁體中文—臺灣)"
  homepage "https://github.com/notofonts/noto-cjk/tree/main/Serif"

  livecheck do
    url :url
    regex(/^Serif(\d+(?:\.\d+)+)$/i)
  end

  font "OTF/TraditionalChinese/NotoSerifCJKtc-Black.otf"
  font "OTF/TraditionalChinese/NotoSerifCJKtc-Bold.otf"
  font "OTF/TraditionalChinese/NotoSerifCJKtc-ExtraLight.otf"
  font "OTF/TraditionalChinese/NotoSerifCJKtc-Light.otf"
  font "OTF/TraditionalChinese/NotoSerifCJKtc-Medium.otf"
  font "OTF/TraditionalChinese/NotoSerifCJKtc-Regular.otf"
  font "OTF/TraditionalChinese/NotoSerifCJKtc-SemiBold.otf"

  # No zap stanza required
end
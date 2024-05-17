cask "font-noto-serif-cjk-jp" do
  version "2.002"
  sha256 "166a03cc7725f4d52a0533f4137991089e55d1d417b9d7e15197a9d483b41de3"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSerif#{version}07_NotoSerifCJKjp.zip"
  name "Noto Serif CJK JP"
  desc "Language Specific OTFs Japanese (日本語)"
  homepage "https:github.comnotofontsnoto-cjktreemainSerif"

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
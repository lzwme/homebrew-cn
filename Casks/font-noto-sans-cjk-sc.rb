cask "font-noto-sans-cjk-sc" do
  version "2.004"
  sha256 "a927e56f53bd6c3b920bc139c0b94aa36c7d9ad0cf009b159437a1a003581140"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSans#{version}08_NotoSansCJKsc.zip"
  name "Noto Sans CJK SC"
  desc "Language Specific OTFs Simplified Chinese (简体中文)"
  homepage "https:github.comnotofontsnoto-cjktreemainSans"

  livecheck do
    cask "font-noto-sans-cjk"
  end

  font "NotoSansCJKsc-Black.otf"
  font "NotoSansCJKsc-Bold.otf"
  font "NotoSansCJKsc-DemiLight.otf"
  font "NotoSansCJKsc-Light.otf"
  font "NotoSansCJKsc-Medium.otf"
  font "NotoSansCJKsc-Regular.otf"
  font "NotoSansCJKsc-Thin.otf"

  # No zap stanza required
end
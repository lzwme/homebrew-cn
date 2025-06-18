cask "font-noto-sans-cjk-tc" do
  version "2.004"
  sha256 "8ea0d6feb8e092c250710cdc75c138090832ddaa98d8ccb37cd89b03b72c331b"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSans#{version}09_NotoSansCJKtc.zip"
  name "Noto Sans CJK TC"
  homepage "https:github.comnotofontsnoto-cjktreemainSans"

  livecheck do
    cask "font-noto-sans-cjk"
  end

  no_autobump! because: :requires_manual_review

  font "NotoSansCJKtc-Black.otf"
  font "NotoSansCJKtc-Bold.otf"
  font "NotoSansCJKtc-DemiLight.otf"
  font "NotoSansCJKtc-Light.otf"
  font "NotoSansCJKtc-Medium.otf"
  font "NotoSansCJKtc-Regular.otf"
  font "NotoSansCJKtc-Thin.otf"

  # No zap stanza required
end
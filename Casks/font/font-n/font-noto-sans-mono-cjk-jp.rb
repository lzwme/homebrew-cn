cask "font-noto-sans-mono-cjk-jp" do
  version "2.004"
  sha256 "6c8faf475ce78fa37486dd5d8920e4bb4450b1b0f3c497edf3ba2d25cf52ab78"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSans#{version}11_NotoSansMonoCJKjp.zip"
  name "Noto Sans Mono CJK JP"
  homepage "https:github.comnotofontsnoto-cjktreemainSans"

  livecheck do
    cask "font-noto-sans-cjk"
  end

  no_autobump! because: :requires_manual_review

  font "NotoSansMonoCJKjp-Bold.otf"
  font "NotoSansMonoCJKjp-Regular.otf"

  # No zap stanza required
end
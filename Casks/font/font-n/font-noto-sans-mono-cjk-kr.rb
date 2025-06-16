cask "font-noto-sans-mono-cjk-kr" do
  version "2.004"
  sha256 "8c1368d3faac3c43991a91392fb73d985409ffe078cb731c7e303e226e4fd619"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSans#{version}12_NotoSansMonoCJKkr.zip"
  name "Noto Sans Mono CJK KR"
  homepage "https:github.comnotofontsnoto-cjktreemainSans"

  no_autobump! because: :requires_manual_review

  livecheck do
    cask "font-noto-sans-cjk"
  end

  font "NotoSansMonoCJKkr-Bold.otf"
  font "NotoSansMonoCJKkr-Regular.otf"

  # No zap stanza required
end
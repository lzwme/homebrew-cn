cask "font-noto-sans-cjk" do
  version "2.004"
  sha256 "a56077736038875f3a5b1e6715b2713a2bd049cc0bf0dfdf645927b070d38bfc"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSans#{version}00_NotoSansCJK.ttc.zip"
  name "Noto Sans CJK"
  homepage "https:github.comnotofontsnoto-cjktreemainSans"

  no_autobump! because: :requires_manual_review

  livecheck do
    url :url
    regex(^(?:Noto)?Sans[._-]?v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  font "NotoSansCJK.ttc"

  # No zap stanza required
end
cask "font-noto-sans-mono-cjk-tc" do
  version "2.004"
  sha256 "0126cbeef724edf21fbaeb113739adf392679fd90a2897c76159d1141df9e8c6"

  url "https:github.comnotofontsnoto-cjkreleasesdownloadSans#{version}14_NotoSansMonoCJKtc.zip"
  name "Noto Sans Mono CJK TC"
  homepage "https:github.comnotofontsnoto-cjktreemainSans"

  livecheck do
    cask "font-noto-sans-cjk"
  end

  no_autobump! because: :requires_manual_review

  font "NotoSansMonoCJKtc-Bold.otf"
  font "NotoSansMonoCJKtc-Regular.otf"

  # No zap stanza required
end
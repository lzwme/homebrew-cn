cask "font-fantasque-sans-mono-noloopk" do
  version "1.8.0"
  sha256 "f7bddc6f1e5a6e0830e332394b1ade52980c784dc4a383cdbee8c568ed0bf3c1"

  url "https://ghfast.top/https://github.com/belluzj/fantasque-sans/releases/download/v#{version}/FantasqueSansMono-NoLoopK.zip"
  name "Fantasque Sans Mono NoLoopK"
  homepage "https://github.com/belluzj/fantasque-sans"

  no_autobump! because: :requires_manual_review

  font "OTF/FantasqueSansMono-Bold.otf"
  font "OTF/FantasqueSansMono-BoldItalic.otf"
  font "OTF/FantasqueSansMono-Italic.otf"
  font "OTF/FantasqueSansMono-Regular.otf"

  # No zap stanza required
end
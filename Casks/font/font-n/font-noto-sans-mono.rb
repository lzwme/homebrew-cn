cask "font-noto-sans-mono" do
  version "2.014"
  sha256 "090cf6c5e03f337a755630ca888b1fef463e64ae7b33ee134e9309c05f978732"

  url "https:github.comnotofontslatin-greek-cyrillicreleasesdownloadNotoSansMono-v#{version}NotoSansMono-v#{version}.zip",
      verified: "github.comnotofonts"
  name "Noto Sans"
  desc "Monospaced variable font"
  homepage "https:notofonts.github.io"

  livecheck do
    url :url
    regex(^NotoSansMono-v?(\d+(?:\.\d+)+)$i)
  end

  font "NotoSansMonounhintedvariableNotoSansMono[wdth,wght].ttf"

  # No zap stanza required
end
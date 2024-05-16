cask "font-koh-santepheap" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkohsantepheap"
  name "Koh Santepheap"
  desc "Khmer font for body text"
  homepage "https:fonts.google.comspecimenKoh+Santepheap"

  font "KohSantepheap-Black.ttf"
  font "KohSantepheap-Bold.ttf"
  font "KohSantepheap-Light.ttf"
  font "KohSantepheap-Regular.ttf"
  font "KohSantepheap-Thin.ttf"

  # No zap stanza required
end
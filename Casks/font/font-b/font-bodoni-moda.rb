cask "font-bodoni-moda" do
  version "2.3"
  sha256 "787426889302f357b1e108fd5284fbe9d40063cb0c994d936c7b6a99816f8ccc"

  url "https://ghfast.top/https://github.com/indestructible-type/Bodoni/releases/download/#{version}/Bodoni-master.zip",
      verified: "github.com/indestructible-type/Bodoni/"
  name "Bodoni Moda"
  homepage "https://indestructibletype.com/Bodoni.html"

  no_autobump! because: :requires_manual_review

  font "Bodoni-master/fonts/variable/Bodoni-Italic-VF.ttf"
  font "Bodoni-master/fonts/variable/Bodoni-VF.ttf"

  # No zap stanza required
end
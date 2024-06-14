cask "font-bodoni-moda" do
  version "2.3"
  sha256 "787426889302f357b1e108fd5284fbe9d40063cb0c994d936c7b6a99816f8ccc"

  url "https:github.comindestructible-typeBodonireleasesdownload#{version}Bodoni-master.zip",
      verified: "github.comindestructible-typeBodoni"
  name "Bodoni Moda"
  homepage "https:indestructibletype.comBodoni.html"

  font "Bodoni-masterfontsvariableBodoni-Italic-VF.ttf"
  font "Bodoni-masterfontsvariableBodoni-VF.ttf"

  # No zap stanza required
end
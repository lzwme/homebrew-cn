cask "excalidrawz" do
  version "1.4.4"
  sha256 "44f17f77503f303626eb9c20fcedbb39be7a991441d9531e5defa9e3b141b660"

  url "https:github.comchocofordExcalidrawZreleasesdownloadv#{version}ExcalidrawZ.#{version}.dmg",
      verified: "github.comchocofordExcalidrawZreleasesdownload"
  name "ExcalidrawZ"
  desc "Excalidraw client"
  homepage "https:excalidrawz.chocoford.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "ExcalidrawZ.app"

  zap trash: [
    "~LibraryApplication Scriptscom.chocoford.excalidraw",
    "~LibraryContainerscom.chocoford.excalidraw",
  ]
end
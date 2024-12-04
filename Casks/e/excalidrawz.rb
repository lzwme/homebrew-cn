cask "excalidrawz" do
  version "1.2.5"
  sha256 "3074d33948e377e41e81c0e11a56b014400d18e8e4860816f5a26c702c99b390"

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
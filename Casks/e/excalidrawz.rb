cask "excalidrawz" do
  version "1.2.7"
  sha256 "9d824201f9123cf115c6a468ad8170c117587cfccb9de59c8fbcb97dc9e04e49"

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
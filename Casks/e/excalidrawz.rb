cask "excalidrawz" do
  version "1.2.4"
  sha256 "9389cca601e1eab225f98a6423b46baec685e826981c8a8bd1d99eb364730dbe"

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
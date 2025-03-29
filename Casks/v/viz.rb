cask "viz" do
  version "2.2"
  sha256 "a747243afbf2a7b0af8777c3d64e3b0383c55710e1c35b2f0505d3b62b8c75e5"

  url "https:github.comalienator88Vizreleasesdownload#{version}Viz.zip",
      verified: "github.comalienator88Viz"
  name "Viz"
  desc "Utility for extracting text from images, videos, QR codes and barcodes"
  homepage "https:itsalin.comappInfo?id=viz"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Viz.app"

  uninstall quit:       "com.alienator88.Viz",
            login_item: "Viz"

  zap trash: [
    "~LibraryApplication Supportcom.alienator88.Viz",
    "~LibraryCachescom.alienator88.viz",
    "~LibraryHTTPStoragescom.alienator88.Viz",
    "~LibraryPreferencescom.alienator88.Viz.plist",
  ]
end
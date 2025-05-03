cask "viz" do
  version "2.2.1"
  sha256 "245206dcb6f9226fc1e408ce3d4d8bf28a55f393bf1192ae358324141928f6b0"

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
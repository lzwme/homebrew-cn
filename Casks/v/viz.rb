cask "viz" do
  version "1.6"
  sha256 "c2d68bd36962d95fe411f355913535620669ad98f80a3faffa0e33c0e43bde78"

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
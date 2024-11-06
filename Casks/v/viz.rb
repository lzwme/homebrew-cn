cask "viz" do
  version "1.7"
  sha256 "3da80a3fd54d65dea19fd60d49b05dfa07460d956560cb74a36d6c8a43bedc7b"

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
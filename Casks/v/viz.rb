cask "viz" do
  version "1.9"
  sha256 "941521b530315ef772dacaa97aa5348839cb2124b691e6b49f3da25d772a6569"

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
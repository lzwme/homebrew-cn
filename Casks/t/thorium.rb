cask "thorium" do
  version "2.4.2"
  sha256 "35f54a2fc43b342c8c9f2d5a32e69f9c10db33c1ff3b5ff41832c6463b0ad91f"

  url "https:github.comedrlabthorium-readerreleasesdownloadv#{version}Thorium-#{version}.dmg",
      verified: "github.comedrlabthorium-reader"
  name "Thorium Reader"
  desc "Epub reader"
  homepage "https:www.edrlab.orgsoftwarethorium-reader"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Thorium.app"

  zap trash: [
    "~LibraryApplication SupportEDRLab.ThoriumReader",
    "~LibraryPreferencesio.github.edrlab.thorium.plist",
  ]
end
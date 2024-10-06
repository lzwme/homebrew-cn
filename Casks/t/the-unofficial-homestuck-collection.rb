cask "the-unofficial-homestuck-collection" do
  version "2.5.6"
  sha256 "2090a531312c5baa8d56e426ebe53c7b11e91f09981af599605799e4d4f3a33a"

  url "https:github.comBamboshunofficial-homestuck-collectionreleasesdownloadv#{version}The-Unofficial-Homestuck-Collection-#{version}.dmg",
      verified: "github.comBamboshunofficial-homestuck-collection"
  name "The Unofficial Homestuck Collection"
  desc "Offline viewer for the webcomic Homestuck"
  homepage "https:bambosh.github.iounofficial-homestuck-collection"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "The Unofficial Homestuck Collection.app"

  zap trash: [
    "~LibraryApplication Supportunofficial-homestuck-collection",
    "~LibraryPreferencescom.bambosh.unofficialhomestuckcollection.plist",
    "~LibrarySaved Application Statecom.bambosh.unofficialhomestuckcollection.savedState",
  ]

  caveats do
    requires_rosetta
    <<~EOS
      You will need to download the corresponding Asset Pack by visiting:
        https:bambosh.github.iounofficial-homestuck-collection
    EOS
  end
end
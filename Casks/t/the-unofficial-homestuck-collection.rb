cask "the-unofficial-homestuck-collection" do
  version "2.6.6"
  sha256 "89795db3700de59354cd82fbe0c98c8b6a952ab98543758742be61f5e0af4466"

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
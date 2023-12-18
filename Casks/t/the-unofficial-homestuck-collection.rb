cask "the-unofficial-homestuck-collection" do
  version "2.0.7"
  sha256 "dd29899a8aec948da21b6318d5ec51b3c9b74e141fbfe28056cdbe1f1a75b12c"

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

  caveats <<~EOS
    You will need to download the corresponding Asset Pack by visiting:
      #{Formatter.url(homepage)}
  EOS
end
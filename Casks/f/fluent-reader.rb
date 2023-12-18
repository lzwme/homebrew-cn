cask "fluent-reader" do
  version "1.1.4"
  sha256 "cdcac2ad7199b214be1c4fe0f0f0c936c86ef87c2e173fb87e9395652399cad6"

  url "https:github.comyang991178fluent-readerreleasesdownloadv#{version}Fluent.Reader.#{version}.dmg",
      verified: "github.comyang991178fluent-reader"
  name "Fluent Reader"
  desc "RSSAtom news aggregator"
  homepage "https:hyliu.mefluent-reader"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "Fluent Reader.app"

  zap trash: [
    "~LibraryApplication Supportfluent-reader",
    "~LibraryPreferencesme.hyliu.fluentreader.plist",
    "~LibrarySaved Application Stateme.hyliu.fluentreader.savedState",
  ]
end
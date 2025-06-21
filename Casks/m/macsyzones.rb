cask "macsyzones" do
  version "1.7"
  sha256 "db99b31f46748a71c5c23c072ae7155e4814e391f31beb18373be7f5150fe322"

  url "https:github.comrohanrhuMacsyZonesreleasesdownloadv#{version}MacsyZones.zip",
      verified: "github.comrohanrhuMacsyZones"
  name "MacsyZones"
  desc "Window management utility"
  homepage "https:macsyzones.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "MacsyZones.app"

  zap trash: [
    "~LibraryApplication SupportMacsyZones",
    "~LibraryLogsMacsyZones",
    "~LibraryPreferencescom.macsyzones.MacsyZones.plist",
  ]
end
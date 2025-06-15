cask "qdirstat" do
  version "1.9-2"
  sha256 "c954d11fca3335073c007c4ba1c8fc4954a1b81fbbf08146bffaa1fe6c2ca721"

  url "https:github.comjesusha123qdirstat-macosreleasesdownload#{version}QDirStat-#{version}.dmg"
  name "QDirStat"
  desc "Disk utilisation visualiser"
  homepage "https:github.comjesusha123qdirstat-macos"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "QDirStat.app"

  zap trash: [
    "~LibraryPreferencescom.qdirstat.QDirStat*.plist",
    "~LibraryPreferencescom.yourcompany.qdirstat.plist",
    "~LibrarySaved Application Statecom.yourcompany.qdirstat.savedState",
  ]
end
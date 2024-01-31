cask "rsyncui" do
  version "1.8.6"
  sha256 "1fe9f7141aba282e60058653a13a6599af74712bcb39ba066ef7d0779911c6a8"

  url "https:github.comrsyncOSXRsyncUIreleasesdownloadv#{version}RsyncUI.#{version}.dmg"
  name "RsyncUI"
  desc "GUI for rsync"
  homepage "https:github.comrsyncOSXRsyncUI"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "RsyncUI.app"

  zap trash: [
    "~LibraryCachesno.blogspot.RsyncUI",
    "~LibraryPreferencesno.blogspot.RsyncUI.plist",
    "~LibrarySaved Application Stateno.blogspot.RsyncUI.savedState",
  ]
end
cask "rsyncui" do
  version "2.3.4"
  sha256 "4c42b017b2b0ceac1672e79dd49e21b66c8227b05127bec479d05ca901f44336"

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
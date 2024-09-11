cask "rsyncui" do
  version "2.1.1"
  sha256 "d02c46047ee1d837074b76c9989766e09285e025a41744c0d16556632a57f409"

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
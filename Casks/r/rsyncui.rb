cask "rsyncui" do
  version "2.1.8"
  sha256 "cb1219863ef1d7af27fb559cfb190ba97371b4664d22ef3461dc52f44cdaa34c"

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
cask "rsyncui" do
  version "1.8.1"
  sha256 "2090b887de5ba695cdfcfb11333bfae4453ff998679142f92e1bcb7323d5040b"

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
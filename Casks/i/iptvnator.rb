cask "iptvnator" do
  version "0.15.1"
  sha256 "b3d21827abe9bd168f016a72add6601b644a3ffdc33912da1bed0d88054dab30"

  url "https:github.com4grayiptvnatorreleasesdownloadv#{version}IPTVnator-#{version}-universal.dmg"
  name "IPTVnator"
  desc "Open Source m3u, m3u8 player"
  homepage "https:github.com4grayiptvnator"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "iptvnator.app"

  zap trash: [
    "~LibraryApplication Supportiptvnator",
    "~LibraryPreferencescom.electron.iptvnator.plist",
    "~LibrarySaved Application Statecom.electron.iptvnator.savedState",
  ]
end
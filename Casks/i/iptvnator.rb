cask "iptvnator" do
  version "0.16.0"
  sha256 "ccea0edb6237fc4e94be5119d111b2479774cc459fb758ab14f7abb7031180c5"

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
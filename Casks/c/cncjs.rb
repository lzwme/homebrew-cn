cask "cncjs" do
  arch arm: "arm64", intel: "x64"

  version "1.10.5"
  sha256 arm:   "1badd649a8137c3f6c9356f6aaacd0380a5a1f2906da0e93357997f638a4a4d0",
         intel: "9232d24fe72866baab424df7ae1b160e74baee26215b342bb1353218d0280a58"

  url "https:github.comcncjscncjsreleasesdownloadv#{version}cncjs-app-#{version}-macos-#{arch}.dmg",
      verified: "github.comcncjscncjs"
  name "CNSjs"
  desc "Interface for CNC milling controllers"
  homepage "https:cnc.js.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "CNCjs.app"

  zap trash: [
    "~.cncjs-sessions",
    "~LibraryApplication SupportCNCjs",
    "~LibraryPreferencesorg.cncjs.plist",
    "~LibrarySaved Application Stateorg.cncjs.savedState",
  ]
end
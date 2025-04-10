cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.4.0"
  sha256 arm:   "e176d82ce507ef36cfe6b89353e74e80112ac1de543706d64d130af7157686f8",
         intel: "ebc7ce821a4411ed34c0c8dec62dea3aa815cc8350a41572e08545f479488870"

  url "https:github.comChurchAppsFreeShowreleasesdownloadv#{version}FreeShow-#{version}-#{arch}.zip",
      verified: "github.comChurchApps"
  name "FreeShow"
  desc "Presentation software"
  homepage "https:freeshow.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "FreeShow.app"

  zap trash: [
        "~LibraryApplication Supportfreeshow",
        "~LibraryPreferencesapp.freeshow.plist",
        "~LibrarySaved Application Stateapp.freeshow.savedState",
      ],
      rmdir: "~DocumentsFreeShow"
end
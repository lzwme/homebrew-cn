cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.2.4"
  sha256 arm:   "38f36e7c6bf726ceaa365a6923e6b21a8c5500d45ea4d155f95ff6eeddd4dc74",
         intel: "61b4b39ae41288d4ae757b3246e4a995b415f2842abf3d1930a3480ee21a4d98"

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
  depends_on macos: ">= :high_sierra"

  app "FreeShow.app"

  zap trash: [
        "~LibraryApplication Supportfreeshow",
        "~LibraryPreferencesapp.freeshow.plist",
        "~LibrarySaved Application Stateapp.freeshow.savedState",
      ],
      rmdir: "~DocumentsFreeShow"
end
cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.3.5"
  sha256 arm:   "d9263ad23bf894c6cd10f8f65ee7afbf2da3fe323b2605a51fc0b9582e53201f",
         intel: "6565c346e4286d1797878b94d35b32270755b0cf4f038c70e52bac81e4d230ed"

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
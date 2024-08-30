cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.2.6"
  sha256 arm:   "f2c0896cca1f4f6426f65562af5dbfb4cb4fe67bdf536517837876931288b405",
         intel: "434a6c336f91c945558b390589e7abc0dd0726667be86066fd89212e65c191cf"

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
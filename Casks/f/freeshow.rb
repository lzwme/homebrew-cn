cask "freeshow" do
  version "1.1.5"
  sha256 "f2c9246f319be66fc8c38f09337f0d3d5928dc69fb35b0031ebb3c78097d13f9"

  url "https:github.comChurchAppsFreeShowreleasesdownloadv#{version}FreeShow-#{version}.dmg",
      verified: "github.comChurchApps"
  name "FreeShow"
  desc "Presentation software"
  homepage "https:freeshow.app"

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
cask "freeshow" do
  version "1.1.4"
  sha256 "d4e29948f892044869fa971a3143ecd7ed8981a0946cedac8624cf6222734e36"

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
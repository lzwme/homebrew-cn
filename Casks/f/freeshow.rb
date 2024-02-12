cask "freeshow" do
  version "1.1.3"
  sha256 "75f66b670bfdefe25e94d414b9bf300dd5d80622615dde13198515323ce4ea2e"

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
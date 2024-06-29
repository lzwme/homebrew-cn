cask "freeshow" do
  arch arm: "-arm64"

  version "1.1.9"
  sha256 arm:   "4c129341701d55d32ba1d1ed09dc3a5c31a82a70769262177108d64c969965f9",
         intel: "4a49f9db3dfec746d05cfad5637e7101bc279abea76ade0656c8fc2f29ae121a"

  url "https:github.comChurchAppsFreeShowreleasesdownloadv#{version}FreeShow-#{version}#{arch}-mac.zip",
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
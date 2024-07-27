cask "freeshow" do
  arch arm: "-arm64"

  version "1.2.1"
  sha256 arm:   "3786616e1e70c6e40456f2a75f070a70bb446c5521bb8fe70be30d4be9163434",
         intel: "5fb6a19a4d1e4b8245d35447391df31c804fee1ae554f91b92ae2164fc7d6388"

  url "https:github.comChurchAppsFreeShowreleasesdownloadv#{version}FreeShow-#{version}#{arch}-mac.zip",
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
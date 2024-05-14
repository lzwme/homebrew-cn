cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.1.6"
  sha256 arm:   "3217266524a386c647e989f341345777fcaa2d89c41505f98cb642e56894e68e",
         intel: "0c5ae12c3f853528ad11c8018d094864b9b4d3470f7e068c594926f2464cb1f1"

  url "https:github.comChurchAppsFreeShowreleasesdownloadv#{version}FreeShow-#{version}-#{arch}-mac.zip",
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
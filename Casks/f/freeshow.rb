cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.4.4"
  sha256 arm:   "d11b617b71b4484d5ec7618b3d31943ee5e07873f0719044c58019fd626698b7",
         intel: "56911186b5616d489b46272206df47c8ab185c770b3ca23eb54efd93ecac28e6"

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
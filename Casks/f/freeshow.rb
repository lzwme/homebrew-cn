cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.3.9"
  sha256 arm:   "073de7ea647e2af71267e0e360bf6a42d362122c0cce5801845ac2956817e777",
         intel: "41674b4833ac082caa82d4448b5440bb5554ce45a9a7a1aada41eda22e0aa53b"

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
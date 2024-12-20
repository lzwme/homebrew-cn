cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.3.3"
  sha256 arm:   "7cda2998b5c21fca5bc0c42aa6dd1d6bcf8dcddd4d01f8388a4038f19e8e06bd",
         intel: "15d47e40f085b747e0dfaf9e82868bd27ea5293c5e32bc40f23e007b827cbe41"

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
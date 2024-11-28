cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.3.2"
  sha256 arm:   "68f15e1589b952de82301c5b60f88e684e7792809bb13c238c371958087cb82a",
         intel: "7a747c7a8ef3ebe658349020c02f2b2e0433480633f6e8c287a001c02e150927"

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
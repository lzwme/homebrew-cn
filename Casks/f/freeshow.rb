cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.4.2"
  sha256 arm:   "cac8fef1b8f0bd9d7a4a9bd5ac573c4f9dd1acc9851b01d882f41ac14538432e",
         intel: "254779efa07cde286109ae604c7ee7ff4cf9c66e5eb1be34625f68e9ea5ff8f8"

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
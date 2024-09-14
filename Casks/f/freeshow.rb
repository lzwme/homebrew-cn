cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.2.7"
  sha256 arm:   "d1416f826dc989c2e88ce0d31ce27b6f713f79c69bd9bb47cd05a838a70c0f16",
         intel: "150f214ad3f73a5988434a25e3afc1f95fa6b88103d731e53ed455f9353c6b3c"

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
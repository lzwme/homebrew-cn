cask "parsify" do
  arch arm: "arm64", intel: "x64"

  version "2.0.1"
  sha256 arm:   "d4f9027b297089ec755880e95b0d0f4998c4f6988b3f0a845720cbc514b36c38",
         intel: "a2d44bd3c947d73562e73162be276ec62fe6f8f55d1410f211ec487f5f3fb6f0"

  url "https:github.comparsify-devdesktopreleasesdownloadv#{version}Parsify-#{version}-mac-#{arch}.zip",
      verified: "github.comparsify-devdesktop"
  name "Parsify"
  desc "Extensible calculator with unit and currency conversions"
  homepage "https:parsify.app"

  depends_on macos: ">= :high_sierra"

  app "Parsify.app"

  zap trash: [
    "~LibraryApplication SupportParsify Desktop",
    "~LibraryPreferencesapp.parsifydesktop.plist",
    "~LibrarySaved Application Stateapp.parsify.parsifydesktop.savedState",
  ]
end
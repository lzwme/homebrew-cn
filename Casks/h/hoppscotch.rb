cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.2.1-0"
  sha256 arm:   "2b8929feff4582716163d7e9abc20522b19644f2ba0bd9fe49637a43f1455f38",
         intel: "1bb1ca7d63013a27d9e2fb996fc789e4f284152b92613ec54d0ba3dc8612b442"

  url "https:github.comhoppscotchreleasesreleasesdownloadv#{version}Hoppscotch_mac_#{arch}.dmg",
      verified: "github.comhoppscotchreleases"
  name "Hoppscotch"
  desc "Open source API development ecosystem"
  homepage "https:hoppscotch.com"

  depends_on macos: ">= :high_sierra"

  app "Hoppscotch.app"

  zap trash: [
    "~LibraryApplication Supportio.hoppscotch.desktop",
    "~LibraryCachesio.hoppscotch.desktop",
    "~LibrarySaved Application Stateio.hoppscotch.desktop.savedState",
    "~LibraryWebKitio.hoppscotch.desktop",
  ]
end
cask "amie" do
  arch arm: "-arm64"

  version "250514.0.1"
  sha256 arm:   "bd61b6568d3b21ce2b1c33c3a8848ce933ab29a7aff55f4f63380e12519ca3b9",
         intel: "627307be066865d88bfeaf8fe7f3b2762086c1f1a719ced5ae4dc85794986136"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end
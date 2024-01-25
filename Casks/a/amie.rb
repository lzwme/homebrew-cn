cask "amie" do
  arch arm: "-arm64"

  version "240123.1.2"
  sha256 arm:   "a59181917432e38d404d7e1da123f1a9298565897fe8302f9368e613d1c15178",
         intel: "2b1e9f3901743bfd8458a38a9c139b1da5534ab13f9804bcacc0943922f66529"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end
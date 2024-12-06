cask "amie" do
  arch arm: "-arm64"

  version "241205.0.2"
  sha256 arm:   "4ad4eb9e6f11eb792611264d40ec48792b446965f850d7bfeb9ac139e6b90b1f",
         intel: "74e78434d8b741425fa2b2f77428a831da5a27d8b3f0fd6c6e7faba4f9fe70bd"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end
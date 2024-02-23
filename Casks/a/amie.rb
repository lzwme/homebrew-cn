cask "amie" do
  arch arm: "-arm64"

  version "240222.0.0"
  sha256 arm:   "a779d68c5219e9f0596df09f841febbf7571ca84c4c0952297d4f16e20f54616",
         intel: "c245218874390d26ae1a65f5d7d6effc836b35969deec4fc1da83e405ac260a9"

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
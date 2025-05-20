cask "amie" do
  arch arm: "-arm64"

  version "250514.0.5"
  sha256 arm:   "02d89b530fd1cda567f56de5f30e6cf765d319b2c11c5bd061390ce65cd7dfa1",
         intel: "e83b5b2f829829231fc5ed959f755b4ba682e13714fd42aeae4d244a7faa9a28"

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
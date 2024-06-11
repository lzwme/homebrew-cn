cask "amie" do
  arch arm: "-arm64"

  version "240610.0.0"
  sha256 arm:   "0b70f42a071a320ff808a79e9dac8f76f56e980a49df7e77495f48ac6526107f",
         intel: "70a4933e3bdb8292a5329b53438ac77ce2bab133977245d18976f5881674013b"

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
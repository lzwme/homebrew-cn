cask "amie" do
  arch arm: "-arm64"

  version "241203.0.2"
  sha256 arm:   "e3d16d6e1c373ec5c9e5c380d856846092bcb925d8cb2fa97646c63c0f7c7e4c",
         intel: "ced170c665451a17582a143ddbd59015b8f805ebb3e97aaf50fe50eb9cbd7927"

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
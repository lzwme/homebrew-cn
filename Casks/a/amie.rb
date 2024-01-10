cask "amie" do
  arch arm: "-arm64"

  version "240109.0.0"
  sha256 arm:   "cafbedd9f38831a73a64f9d6294d19d04e545f6bd175266a7835b4edf2ae5275",
         intel: "34a7317845c4ec4a14ec2ff38a98bca5891e37d716883bd959af3b4f2daf8524"

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
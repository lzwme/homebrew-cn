cask "amie" do
  arch arm: "-arm64"

  version "240909.0.0"
  sha256 arm:   "60442b7dd2338580812c6b4a016a942f50123bad53d297af5c906f35efd8e990",
         intel: "f7e0220eb029ee3677b5a518a792522582fb5e4d417ebf66f4ff1a8975202100"

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
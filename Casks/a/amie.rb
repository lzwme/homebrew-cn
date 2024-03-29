cask "amie" do
  arch arm: "-arm64"

  version "240328.0.0"
  sha256 arm:   "8ca54a62f729583ac3c9c3292d0ba33d5ad7ad7b599686bf25cd6fb1039b84ef",
         intel: "02feaeb99ad8474d927e868daaff9fefb5cf59b30cddec586771834dad6a8373"

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
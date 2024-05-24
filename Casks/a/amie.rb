cask "amie" do
  arch arm: "-arm64"

  version "240523.0.0"
  sha256 arm:   "1f60b9f341e1e2950c423cf5228c0d86baa9613e61d9103f72b6040ae1f8476b",
         intel: "c08d830574e81864f9ea04b4179d656649534fe372a7542801935ab10ec6f38c"

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
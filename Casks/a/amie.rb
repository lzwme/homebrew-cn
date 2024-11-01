cask "amie" do
  arch arm: "-arm64"

  version "241031.0.2"
  sha256 arm:   "4967d7cd9cee04736fa2ccfe748482be196a8f84e45ae95d8a1dbbd8ccaad991",
         intel: "c4dc8208f76e6c7eb87c717a9d932d43ff2a38e4121ce0c1b8381185f6c20000"

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
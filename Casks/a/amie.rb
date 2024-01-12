cask "amie" do
  arch arm: "-arm64"

  version "240111.0.0"
  sha256 arm:   "f229e88e7fac7b74095eaf72df26f615dbf3d7e5be765f560f537d0e375ed7dd",
         intel: "028226fe246d34e206715fcaa6121578e2d62c5838e9e9e95a018aa238d9aab0"

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
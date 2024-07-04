cask "amie" do
  arch arm: "-arm64"

  version "240703.1.0"
  sha256 arm:   "fa6afab6133ebcefc3f91bf2802c84b293d28c0e51f59087fbd67ad43a98bb2c",
         intel: "ded617803633146284a10adef08b8793c6aa8244cc044686bb2808c76de46423"

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
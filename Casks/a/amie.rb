cask "amie" do
  arch arm: "-arm64"

  version "240326.0.4"
  sha256 arm:   "76683281c5f9ebe1a1cef8178b5d059982401e604936f5480d439b84302034a3",
         intel: "69929b493744bc4ea0f35bfd4a8eb6ec15b0dae65f6304ec6311a3bf9a742e94"

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
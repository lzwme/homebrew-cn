cask "amie" do
  arch arm: "-arm64"

  version "240613.0.0"
  sha256 arm:   "7b107eff72e5ad8d10eff3709f63a7a7d0d028f5b8de6d1ce665ca6c0f9652c7",
         intel: "af18dcab8492d2617413eb79556a4b24d18411ef5b2f17e4ca552776011b80fe"

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
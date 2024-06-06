cask "amie" do
  arch arm: "-arm64"

  version "240605.0.2"
  sha256 arm:   "7a06db7fcbfe60aa7e819a9b728f4bed1f77c9aa3962322d52d207f811051231",
         intel: "ef27ba9d0c9ca7e4f12a6dff51805664a64a33b6b450ac0efc42b95f6ed835dd"

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
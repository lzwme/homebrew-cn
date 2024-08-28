cask "amie" do
  arch arm: "-arm64"

  version "240827.0.0"
  sha256 arm:   "d792d6992efc89a9b9a4587141c90d70a7b8d4bd33cd7ad77ed177553c3bfa4e",
         intel: "73509a4bdbf14793f5222ac54a019f4d17aea66882933ef47f5c6d5eb45bae17"

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
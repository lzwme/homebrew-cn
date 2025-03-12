cask "amie" do
  arch arm: "-arm64"

  version "250307.0.7"
  sha256 arm:   "736a521ad7a8d1f5e0708a9a74bcc9e6f70ef018d6d6743d44ea04a9230fe908",
         intel: "a16498d72a0ec4802aa0270bae2246e324f4b82e3f70010c28b7300ac8b0c0ba"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end
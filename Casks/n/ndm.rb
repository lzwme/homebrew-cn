cask "ndm" do
  version "1.2.0"
  sha256 "7feea9270a35f5c3675abec49c6c38e83796f2a9c81040a190932d069e68a921"

  url "https:github.com720kbndmreleasesdownloadv#{version}ndm-#{version}.dmg",
      verified: "github.com720kbndm"
  name "ndm"
  desc "Desktop manager for the Node.js Package Manager (NPM)"
  homepage "https:720kb.github.iondm"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "ndm.app"

  zap trash: [
    "~LibraryApplication Supportndm",
    "~LibraryPreferencesnet.720kb.ndm.helper.plist",
    "~LibraryPreferencesnet.720kb.ndm.plist",
    "~LibrarySaved Application Statenet.720kb.ndm.savedState",
  ]
end
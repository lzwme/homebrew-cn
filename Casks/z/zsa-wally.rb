cask "zsa-wally" do
  version "2.1.0"
  sha256 "23f2770744800ba2af2f33caa297c6621a6610c4999ad0d3cf7673a5060c2a44"

  url "https:github.comzsawallyreleasesdownload#{version}-osxwally-osx-#{version}.dmg",
      verified: "github.comzsawally"
  name "Wally"
  desc "Flash tool for ZSA keyboards"
  homepage "https:ergodox-ez.compageswally"

  disable! date: "2024-12-16", because: :discontinued, replacement_cask: "keymapp"

  app "Wally.app"

  zap trash: [
    "~LibraryPreferencescom.zsa.wally.plist",
    "~LibrarySaved Application Statecom.zsa.wally.savedState",
  ]
end
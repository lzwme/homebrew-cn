cask "qtpass" do
  version "1.4.0"
  sha256 "cef58227b50f3eda4e4c150cb0afc7875c55c9226a91076d41e44b897629a92b"

  url "https:github.comIJHackqtpassreleasesdownloadv#{version}qtpass-#{version}.dmg",
      verified: "github.comIJHackqtpass"
  name "QtPass"
  desc "Multi-platform GUI for pass, the standard unix password manager"
  homepage "https:qtpass.org"

  depends_on macos: ">= :sierra"

  app "QtPass.app"

  zap trash: [
    "~LibraryPreferencesorg.ijhack.QtPass.plist",
    "~LibrarySaved Application Stateorg.qtpass.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
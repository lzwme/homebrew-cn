cask "sengi" do
  version "1.8.0"
  sha256 "dcdb16ba013326735c89c6bc1a2050194af7d570625979173f1396c21344bef7"

  url "https:github.comNicolasConstantsengi-electronreleasesdownloadv#{version}Sengi-#{version.major_minor_patch}-mac.dmg"
  name "Sengi"
  desc "Mastodon and Pleroma desktop client"
  homepage "https:github.comNicolasConstantsengi"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Sengi.app"

  zap trash: [
    "~LibraryApplication Supportsengi",
    "~LibraryPreferencesorg.sengi.desktop.plist",
    "~LibrarySaved Application Stateorg.sengi.desktop.savedState",
  ]
end
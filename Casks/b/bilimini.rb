cask "bilimini" do
  version "1.5.7"
  sha256 "d6c92362253c0d41cabd3440b2e72e25bb0da157d2bf87c7ef989e4ff28a1563"

  url "https:github.comchitosaibiliminireleasesdownloadv#{version}bilimini-#{version}-mac.zip"
  name "bilimini"
  desc "Small window bilibili client"
  homepage "https:github.comchitosaibilimini"

  auto_updates true

  app "bilimini.app"

  zap trash: [
    "~LibraryApplication Supportbilimini",
    "~LibraryPreferencescom.electron.bilimini.plist",
    "~LibrarySaved Application Statecom.electron.bilimini.savedState",
  ]
end
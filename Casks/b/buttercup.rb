cask "buttercup" do
  version "2.26.5"
  sha256 "f0f86db5e70c17d0a4b8690b627111eccce30e69fcf9d9138ab26e6fc4138f46"

  url "https:github.combuttercupbuttercup-desktopreleasesdownloadv#{version}Buttercup-mac-x64-#{version}.dmg",
      verified: "github.combuttercupbuttercup-desktop"
  name "Buttercup"
  desc "Javascript Secrets Vault - Multi-Platform Desktop Application"
  homepage "https:buttercup.pw"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Buttercup.app"

  zap trash: [
    "~LibraryApplication SupportButtercup",
    "~LibraryApplication SupportButtercup-nodejs",
    "~LibraryLogsButtercup-nodejs",
    "~LibraryPreferencesButtercup-nodejs",
    "~LibraryPreferencespw.buttercup.desktop.plist",
    "~LibrarySaved Application Statepw.buttercup.desktop.savedState",
  ]
end
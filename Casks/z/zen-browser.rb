cask "zen-browser" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.7.1b"
  sha256 arm:   "fe2ba05261bcab2c0934773e6d1385dbe68a5ac1da790d064b63292a22e0098c",
         intel: "f6be6536e9ea8e95b532baeb196bf584ac81051932cd9056abd9ae50fc4f59e7"

  url "https:github.comzen-browserdesktopreleasesdownload#{version}zen.macos-#{arch}.dmg",
      verified: "github.comzen-browserdesktop"
  name "Zen Browser"
  desc "Gecko based web browser"
  homepage "https:zen-browser.app"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Zen Browser.app"

  zap trash: [
        "~LibraryApplication Supportzen",
        "~LibraryCachesMozillaupdatesApplicationsZen Browser",
        "~LibraryCacheszen",
        "~LibraryPreferencesorg.mozilla.com.zen.browser.plist",
        "~LibrarySaved Application Stateorg.mozilla.com.zen.browser.savedState",
      ],
      rmdir: "~LibraryCachesMozilla"
end
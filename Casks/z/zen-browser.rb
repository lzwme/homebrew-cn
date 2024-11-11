cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.19"
  sha256 arm:   "228f79a57cc8077af46ce5407008b32193e1b01823eaf7fa27a21c39f340b4cf",
         intel: "0f3973a0454f65212bf37ebcf0e9eaf56f5b129cf5c2884beabdbe32dd82c5d9"

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
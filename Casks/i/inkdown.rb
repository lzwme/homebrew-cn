cask "inkdown" do
  arch arm: "arm64", intel: "x64"

  version "1.0.1"
  sha256 arm:   "f8dbee6359711fe0eb4afd22ebe32ac2b7efa5f01b9cc26f248047d0456a8ced",
         intel: "fbfab0cbd5e52ad0c576033d992a7032fa2905357841369814f9568e3e3eafc5"

  url "https:github.com1943timeinkdownreleasesdownloadv#{version}inkdown-mac-#{arch}.dmg"
  name "Inkdown"
  desc "WYSIWYG Markdown editor"
  homepage "https:github.com1943timeinkdown"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Inkdown.app"

  zap trash: [
    "~LibraryApplication Supportinkdown",
    "~LibraryPreferencesinkdown.plist",
    "~LibrarySaved Application Stateinkdown.savedState",
  ]
end
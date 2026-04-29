cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.11.3"
  sha256 arm:   "cc1a69492b5b1079d634d83cfa3635f399ba3f737c9d300a5b258cab9ad0e3ab",
         intel: "9c21d5ec3fa320c3ca0e69a99ba1a5257a30bc51fd5fab25c313d114b6587ee5"

  url "https://ghfast.top/https://github.com/tagspaces/tagspaces/releases/download/v#{version}/tagspaces-mac-#{arch}-#{version}.dmg",
      verified: "github.com/tagspaces/tagspaces/"
  name "TagSpaces"
  desc "Offline, open-source, document manager with tagging support"
  homepage "https://www.tagspaces.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "TagSpaces.app"

  zap trash: [
    "~/Library/Application Support/TagSpaces",
    "~/Library/Preferences/org.tagspaces.desktopapp.plist",
    "~/Library/Saved Application State/org.tagspaces.desktopapp.savedState",
  ]
end
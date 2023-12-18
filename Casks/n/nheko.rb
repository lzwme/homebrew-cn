cask "nheko" do
  arch arm: "apple-silicon", intel: "intel"

  version "0.11.3"
  sha256 arm:   "12a203d8214673182c5b6959c10a28471b2e1f9c24aefb06dfd5537c2c79fa9e",
         intel: "3576e6a94e6caad54aaddbb71436de8adc919deccb571af2bed3c871b630a430"

  url "https:github.comNheko-Rebornnhekoreleasesdownloadv#{version}nheko-v#{version}-#{arch}.dmg",
      verified: "github.comNheko-Rebornnheko"
  name "Nheko"
  desc "Desktop client for the Matrix protocol"
  homepage "https:nheko-reborn.github.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Nheko.app"

  zap trash: [
    "~LibraryApplication Supportnheko",
    "~LibraryCachesnheko",
    "~LibraryPreferencescom.nheko.nheko.plist",
    "~LibrarySaved Application Stateio.github.nheko-reborn.nheko.savedState",
  ]
end
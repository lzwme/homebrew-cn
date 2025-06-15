cask "nheko" do
  arch arm: "apple-silicon", intel: "intel"

  version "0.12.0"
  sha256 arm:   "992b220a0eb65a5e20d869481f3bda756157bfdaa477f474a12e2ae5aa16d7eb",
         intel: "e4d70bf933eda6dfcf23861520b4b3b60166616a633fdb9c46682913bab7070f"

  url "https:github.comNheko-Rebornnhekoreleasesdownloadv#{version}nheko-v#{version}-#{arch}.dmg",
      verified: "github.comNheko-Rebornnheko"
  name "Nheko"
  desc "Desktop client for the Matrix protocol"
  homepage "https:nheko-reborn.github.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "nheko.app"

  zap trash: [
    "~LibraryApplication Supportnheko",
    "~LibraryCachesnheko",
    "~LibraryPreferencescom.nheko.nheko.plist",
    "~LibrarySaved Application Stateio.github.nheko-reborn.nheko.savedState",
  ]
end
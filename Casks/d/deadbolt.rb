cask "deadbolt" do
  arch arm: "-arm64"

  version "2.0.2"
  sha256 arm:   "d5ede4239f0474124bfa11310938d5657d1fc6d550b32fabe1672506ca6e60a7",
         intel: "7ef2584d67b102944da8ec823811488b6a4137f83a4ff8c30d50685e996385f7"

  url "https:github.comalichtmandeadboltreleasesdownloadv#{version}Deadbolt-#{version}#{arch}.dmg"
  name "Deadbolt"
  desc "File encryption tool"
  homepage "https:github.comalichtmandeadbolt"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Deadbolt.app"

  zap trash: [
    "~LibraryApplication Supportdeadbolt",
    "~LibraryPreferencesorg.alichtman.deadbolt.plist",
    "~LibrarySaved Application Stateorg.alichtman.deadbolt.savedState",
  ]
end
cask "there" do
  version "2.0.0"
  sha256 "5a9dd8eebbb385f6fa09309b559f4d0341231519f39527bea2315140f7301c7f"

  url "https:github.comdena-sohrabiTherereleasesdownloadv#{version}There.zip",
      verified: "github.comdena-sohrabiThere"
  name "There"
  desc "Tool to display the local times of friends, teammates, cities or any time zone"
  homepage "https:there.pm"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "There.app"

  uninstall signal: ["TERM", "pm.there.There"]

  zap trash: [
    "~LibraryApplication SupportThere",
    "~LibraryCachespm.there.There",
    "~LibraryLogsThere",
    "~LibraryPreferencespm.there.There.plist",
  ]
end
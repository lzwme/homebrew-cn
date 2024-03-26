cask "stellarium" do
  version "24.1"
  sha256 "ca0fa67fb193d4c7aa5bd1f51840a4d40b3637c009ad228d9108664aa36a7776"

  url "https:github.comStellariumstellariumreleasesdownloadv#{version.major_minor}Stellarium-#{version}-qt6-macOS.zip",
      verified: "github.comStellariumstellarium"
  name "Stellarium"
  desc "Tool to render realistic skies in real time on the screen"
  homepage "https:stellarium.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Stellarium.app"

  zap trash: "~LibraryPreferencesStellarium"
end
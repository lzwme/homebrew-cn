cask "doughnut" do
  version "2.0.1"
  sha256 "56e2a41087ee9793b667feaa1bef2e96e20cee6ff7cd8bee4a9acbd1ca1e8aeb"

  url "https:github.comdyercDoughnutreleasesdownloadv#{version}Doughnut-#{version}.dmg"
  name "Doughnut"
  desc "Podcast client"
  homepage "https:github.comdyercDoughnut"

  app "Doughnut.app"

  zap trash: [
    "~LibraryPreferencescom.cdyer.doughnut.plist",
    "~MusicDoughnut",
  ]
end
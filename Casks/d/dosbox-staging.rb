cask "dosbox-staging" do
  version "0.81.2"
  sha256 "718968485a0418ead3434285e3a6ab4853914d29d38e14289711af1b2152368e"

  url "https:github.comdosbox-stagingdosbox-stagingreleasesdownloadv#{version}dosbox-staging-macOS-v#{version}.dmg"
  name "DOSBox Staging"
  desc "DOS game emulator"
  homepage "https:github.comdosbox-stagingdosbox-staging"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "DOSBox Staging.app"

  zap trash: "~LibraryPreferencesDOSBox"
end
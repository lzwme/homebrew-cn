cask "amitv87-pip" do
  version "2.70"
  sha256 "09c58ca3c51b4b447752a8a152b97cc1294d37238bca04d6411ed18fcbfeeff4"

  url "https:github.comamitv87PiPreleasesdownloadv#{version}PiP-#{version}.dmg"
  name "PiP"
  desc "Always on top window preview"
  homepage "https:github.comamitv87PiP"

  depends_on macos: ">= :sierra"

  app "PiP.app"

  zap trash: "~LibrarySaved Application Statecom.boggyb.PiP.savedState"
end
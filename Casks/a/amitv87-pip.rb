cask "amitv87-pip" do
  version "2.60"
  sha256 "3c7c368f0a1f75e09eb96e043b42af7ce56408df414bfb7f08c48987a4b394b5"

  url "https:github.comamitv87PiPreleasesdownloadv#{version}PiP-#{version}.dmg"
  name "PiP"
  desc "Always on top window preview"
  homepage "https:github.comamitv87PiP"

  depends_on macos: ">= :sierra"

  app "PiP.app"

  zap trash: "~LibrarySaved Application Statecom.boggyb.PiP.savedState"
end
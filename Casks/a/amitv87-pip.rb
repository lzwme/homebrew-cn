cask "amitv87-pip" do
  version "2.50"
  sha256 "9c85f914b34e85482c9f3012a196ef81dff783c5d79465a802340720da423cb4"

  url "https:github.comamitv87PiPreleasesdownloadv#{version}PiP-#{version}.dmg"
  name "PiP"
  desc "Always on top window preview"
  homepage "https:github.comamitv87PiP"

  depends_on macos: ">= :sierra"

  app "PiP.app"

  zap trash: "~LibrarySaved Application Statecom.boggyb.PiP.savedState"
end
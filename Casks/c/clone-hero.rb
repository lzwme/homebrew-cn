cask "clone-hero" do
  version "1.0.0.4080"
  sha256 "7b7d170b344773ce8355a0c3274e4adc1715e7cd978e210d3c701af22df00d5c"

  url "https:github.comclonehero-gamereleasesreleasesdownloadV#{version}CloneHero-mac.dmg",
      verified: "github.comclonehero-game"
  name "Clone Hero"
  desc "Guitar Hero clone"
  homepage "https:clonehero.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Clone Hero.app"

  zap trash: [
    "~LibraryApplication Supportcom.srylain.CloneHero",
    "~LibraryLogssrylain Inc_",
    "~LibraryPreferencescom.srylain.CloneHero.plist",
    "~LibrarySaved Application Statecom.srylain.CloneHero.savedState",
  ]
end
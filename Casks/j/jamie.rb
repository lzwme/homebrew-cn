cask "jamie" do
  version "4.0.5"
  sha256 "ed04ebdfb825081f3e76a93487c50148824d0c220adc7ab964a550d372971a3d"

  url "https:github.comlouismorgnerjamie-releasereleasesdownloadv#{version}jamie-#{version}.dmg",
      verified: "github.comlouismorgnerjamie-release"
  name "jamie"
  desc "AI-powered meeting notes"
  homepage "https:meetjamie.ai"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "jamie.app"

  zap trash: "~LibraryApplication Supportjamie"
end
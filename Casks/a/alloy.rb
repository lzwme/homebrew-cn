cask "alloy" do
  version "6.0.0"
  sha256 "b51300410b96abe696be14be98b5277c8a732f0d7275ea62b83d7ab85151be52"

  url "https:github.comAlloyToolsorg.alloytools.alloyreleasesdownloadv#{version}alloy.dmg",
      verified: "github.comAlloyToolsorg.alloytools.alloy"
  name "Alloy"
  desc "Programming language for software modelling"
  homepage "https:alloytools.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Alloy.app"

  zap trash: "~LibrarySaved Application Stateorg.alloytools.alloy.savedState"

  caveats do
    requires_rosetta
  end
end
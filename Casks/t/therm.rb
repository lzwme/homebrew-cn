cask "therm" do
  version "0.6.4"
  sha256 "96ea558143ae60de68eecbfcd9e70aaeab2901d852189ef364ed2e6fc269d055"

  url "https:github.comtrufaeThermreleasesdownload#{version}Therm-#{version}.zip"
  name "Therm"
  desc "Fork of iTerm2 that aims to have good defaults and minimal features"
  homepage "https:github.comtrufaeTherm"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Therm.app"
end
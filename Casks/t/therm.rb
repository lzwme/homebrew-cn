cask "therm" do
  version "0.6.4"
  sha256 "30b1c67a1d297f5e05de47faa66d6cf118c5a450aac2f222098e4fb1cf80d650"

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
cask "laverna" do
  version "0.7.51"
  sha256 "b5008b0bb25036265b179d3ad0b097de4ee95de75d4ef87ff848dc085395ab50"

  url "https:github.comLavernalavernareleasesdownload#{version}laverna-#{version}-darwin-x64.zip",
      verified: "github.comLavernalaverna"
  name "Laverna"
  desc "Encryption-focused open source note taking application"
  homepage "https:laverna.cc"

  # laverna is unmaintained, see https:github.comLavernalavernaissues998
  deprecate! date: "2024-01-01", because: :unmaintained

  app "laverna.app"

  caveats do
    requires_rosetta
  end
end
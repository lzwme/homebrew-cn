cask "explorer" do
  version "1.104"
  sha256 "fcf3ec43ab2dff7f9e734192d3d327eebce80240007c4848b433f5d0f6ae8605"

  url "https:github.comjfbouzereauexplorerreleasesdownload#{version}Explorer-darwin-x64.zip"
  name "Explorer"
  desc "Data Explorer"
  homepage "https:github.comjfbouzereauexplorer"

  deprecate! date: "2025-04-20", because: :unmaintained

  app "Explorer-darwin-x64.app"

  zap trash: [
    "~LibraryApplication SupportExplorer",
    "~LibraryCachesExplorer",
  ]

  caveats do
    requires_rosetta
  end
end
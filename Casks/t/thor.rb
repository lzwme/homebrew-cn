cask "thor" do
  version "1.5.14"
  sha256 "20061ec1fd2798d1a81c977eee10cbe4fa48e7b31281f047e0da89ee8b0c8b11"

  url "https:github.comgbammcThorreleasesdownload#{version}Thor_#{version}.zip"
  name "Thor"
  desc "Utility to switch between applications"
  homepage "https:github.comgbammcThor"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Thor.app"

  uninstall quit: "me.alvinzhu.Thor"

  zap trash: [
    "~LibraryApplication Scriptsme.alvinzhu.Thor",
    "~LibraryContainersme.alvinzhu.Thor",
  ]

  caveats do
    requires_rosetta
  end
end
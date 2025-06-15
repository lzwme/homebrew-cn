cask "thor" do
  version "1.5.16"
  sha256 "07bd68a6378ac66d00fe39e0f0f0589694b19a46d89120b5934173a8c3b41a5a"

  url "https:github.comgbammcThorreleasesdownload#{version}Thor_#{version}.zip"
  name "Thor"
  desc "Utility to switch between applications"
  homepage "https:github.comgbammcThor"

  livecheck do
    url "https:github.comgbammcThorrawmasterReleasesappcast.xml"
    strategy :sparkle do |items|
      items.map(&:short_version)
    end
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Thor.app"

  uninstall quit: "me.alvinzhu.Thor"

  zap trash: [
    "~LibraryApplication Scriptsme.alvinzhu.Thor",
    "~LibraryContainersme.alvinzhu.Thor",
  ]
end
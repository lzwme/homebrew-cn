cask "bonitastudiocommunity" do
  version "2023.2-u0"
  sha256 "f3afad3ef1735a188b687e3ab16490c82e2faf680ae1240490669aecbe7981a9"

  url "https:github.combonitasoftbonita-platform-releasesreleasesdownload#{version}BonitaStudioCommunity-#{version}-x86_64.dmg",
      verified: "github.combonitasoftbonita-platform-releases"
  name "Bonita Studio Community Edition"
  desc "Business process automation and optimisation"
  homepage "https:www.bonitasoft.comdownloads"

  livecheck do
    url :url
    regex((\d+(?:[.-]\d+)+(?:-\w+)?)i)
    strategy :github_latest
  end

  installer script: {
    executable: "#{staged_path}BonitaStudioCommunity-#{version}.appContentsMacOSinstallbuilder.sh",
    args:       ["--mode", "unattended"],
  }

  uninstall quit:   "org.bonitasoft.studio.product",
            delete: "ApplicationsBonitaStudioCommunity-#{version}.app"

  zap trash: [
    "LibraryCachesorg.bonitasoft.studio.product",
    "~LibraryPreferencesorg.bonitasoft.studio.product.plist",
  ]
end
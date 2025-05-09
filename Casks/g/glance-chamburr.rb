cask "glance-chamburr" do
  version "1.5.1"
  sha256 "a50bed8c4c90f24289c19a27005521b565354539b33a0836b3aa739e31d335f7"

  url "https:github.comchamburrglancereleasesdownloadv#{version}Glance-#{version}.dmg"
  name "Glance"
  desc "Utility to provide quick look previews for files that aren't natively supported"
  homepage "https:github.comchamburrglance"

  depends_on macos: ">= :big_sur"

  app "Glance.app"

  zap trash: [
    "~LibraryApplication Scriptscom.chamburr.Glance",
    "~LibraryApplication Scriptscom.chamburr.Glance.QLPlugin",
    "~LibraryContainerscom.chamburr.Glance",
    "~LibraryContainerscom.chamburr.Glance.QLPlugin",
  ]

  caveats <<~EOS
    You must start #{appdir}Glance.app once manually to setup the Quick Look plugin.
  EOS
end
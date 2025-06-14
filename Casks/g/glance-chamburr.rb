cask "glance-chamburr" do
  version "1.5.2"
  sha256 "c2ee7f62b575fd4482fc4fec2c990c0e4bdf419e58a0dc2f2f918f6b14c0ce0b"

  url "https:github.comchamburrglancereleasesdownloadv#{version}Glance-#{version}.dmg"
  name "Glance"
  desc "Utility to provide quick look previews for files that aren't natively supported"
  homepage "https:github.comchamburrglance"

  no_autobump! because: :requires_manual_review

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
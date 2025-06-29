cask "via" do
  version "3.0.0"
  sha256 "30f9f81154a8ee9c0cf19f4fb1a3d6ca9a448f765122845db1e190b9f583d16b"

  url "https:github.comthe-viareleasesreleasesdownloadv#{version}via-#{version}-mac.dmg",
      verified: "github.comthe-viareleases"
  name "VIA"
  desc "Keyboard configurator"
  homepage "https:caniusevia.com"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "VIA.app"

  zap trash: [
    "~LibraryApplication SupportVIA",
    "~LibraryApplication Supportvia-nativia",
    "~LibraryLogsVIA",
    "~LibraryPreferencesorg.via.configurator.plist",
  ]

  caveats do
    requires_rosetta
  end
end
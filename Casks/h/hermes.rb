cask "hermes" do
  version "1.3.1"
  sha256 "f7c2949e4a44a9183eb6c937b250052867a0373f9de7a8ecbd63853d7df88dbd"

  url "https:github.comHermesAppHermesreleasesdownloadv#{version}Hermes-#{version}.zip",
      verified: "github.comHermesAppHermes"
  name "Hermes"
  desc "Pandora player"
  homepage "https:hermesapp.org"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-12", because: :unmaintained

  auto_updates true

  app "Hermes.app"

  zap trash: [
    "~LibraryApplication SupportHermes",
    "~LibraryCachescom.alexcrichton.Hermes",
    "~LibraryPreferencescom.alexcrichton.Hermes.plist",
  ]

  caveats do
    requires_rosetta
  end
end
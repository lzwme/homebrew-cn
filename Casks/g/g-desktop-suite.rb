cask "g-desktop-suite" do
  version "0.3.1"
  sha256 "461c5d19149a088981f8f7a87148cda1762458b7c64d59e1ec5062106eb8ad90"

  url "https:github.comalexkim205g-desktop-suitereleaseslatestdownloadG-Desktop-Suite-#{version}.dmg"
  name "G Desktop Suite"
  homepage "https:github.comalexkim205g-desktop-suite"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-11", because: :unmaintained

  app "G Desktop Suite.app"

  caveats do
    requires_rosetta
  end
end
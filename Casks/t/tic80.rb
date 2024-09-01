cask "tic80" do
  # NOTE: "80" is not a version number, but an intrinsic part of the product name
  version "1.1.2837"
  sha256 "324e91d08fb5dcfaf2f41dc846b89465074b5db3b5aa63befc3fdb664493c1b9"

  url "https:github.comnesboxTIC-80releasesdownloadv#{version}tic80-v#{version.major_minor}-mac.dmg",
      verified: "github.comnesboxTIC-80"
  name "TIC-80"
  desc "Fantasy computer for making, playing and sharing tiny games"
  homepage "https:tic80.com"

  app "tic80.app"

  uninstall quit: "com.nesbox.tic"

  zap trash: [
    "~LibraryApplication Supportcom.nesbox.tic",
    "~LibrarySaved Application Statecom.nesbox.tic.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
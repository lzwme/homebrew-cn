cask "jazz2-resurrection" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  arch arm: "ARM64", intel: "x64"

  version "2.9.0"
  sha256 "46d6c8d2330aa542e2522e0c6d9df2b4a3ac79b36438d718333117a3ff9f4fbd"

  url "https:github.comdeathkillerjazz2releasesdownload#{version}Jazz2_#{version}_MacOS.zip",
      verified: "github.comdeathkillerjazz2"
  name "Jazz² Resurrection"
  desc "Open-source re-implementation of Jazz Jackrabbit 2 game engine"
  homepage "https:deat.tkjazz2"

  container nested: "#{arch}jazz2_sdl2.dmg"

  app "Jazz² Resurrection.app"

  zap trash: "~LibraryApplication SupportJazz² Resurrection"

  caveats <<~EOS
    Game data should be installed to ~LibraryApplication SupportJazz² ResurrectionSource
  EOS
end
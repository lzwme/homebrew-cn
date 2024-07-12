cask "fspy" do
  version "1.0.3"
  sha256 "3aca686ea9d976580936279fbb3637698a3ba832d3cdd74dbbf79129b4dd2f56"

  url "https:github.comstuffmaticfSpyreleasesdownloadv#{version}fSpy-#{version}.dmg",
      verified: "github.comstuffmaticfSpy"
  name "fSpy"
  desc "Still image camera matching"
  homepage "https:fspy.io"

  app "fSpy.app"

  zap trash: "~LibraryApplication Supportfspy"

  caveats do
    requires_rosetta
  end
end
cask "jumpcut" do
  version "0.84"
  sha256 "ef43d3fee801188a3f6fb9ba14bf738aa2d103bd4986b390e9820e7390c6178c"

  url "https:github.comsnarkjumpcutreleasesdownloadv#{version}Jumpcut-#{version}.tar.bz2",
      verified: "github.comsnarkjumpcut"
  name "Jumpcut"
  desc "Clipboard manager"
  homepage "https:snark.github.iojumpcut"

  depends_on macos: ">= :el_capitan"

  app "Jumpcut.app"

  zap trash: "~LibraryPreferencesnet.sf.Jumpcut.plist"
end
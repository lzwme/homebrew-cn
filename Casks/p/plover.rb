cask "plover" do
  version "4.0.0rc2"
  sha256 "46659da04b7fe04b9b21bda469e292ac53ec005713e5d2d970a90e99e9c2014f"

  url "https:github.comopenstenoprojectploverreleasesdownloadv#{version}plover-#{version}-macosx_10_13_x86_64.dmg",
      verified: "github.comopenstenoprojectplover"
  name "Plover"
  desc "Stenotype engine"
  homepage "https:www.openstenoproject.orgplover"

  livecheck do
    url :url
    regex(v?(\d+(?:\.\d+)+[\w.]+)i)
    strategy :github_latest
  end

  app "Plover.app"

  zap trash: "~LibraryApplication Supportplover"

  caveats do
    requires_rosetta
    <<~EOS
      Version 4 is a major change and the configuration file it creates is not
      compatible with Plover 3 or earlier. Please backup your plover.cfg.
    EOS
  end
end
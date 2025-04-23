cask "plover" do
  version "4.0.1"
  sha256 "cb7c5781387e41ff5e18f7eee5f48f323af230ee5501ce839c9d6d59de726182"

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
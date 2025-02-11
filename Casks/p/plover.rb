cask "plover" do
  version "4.0.0rc5"
  sha256 "3de74ca81b7f137eff636d76c3f0a9b001e9855cd410e84fcd9b78c48d791fcb"

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
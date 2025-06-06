cask "plover" do
  version "4.0.2"
  sha256 "710900e00781e19463a12a9d5d0082b282ce8eb9e93c4c5f5d6fad5aecf0d360"

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
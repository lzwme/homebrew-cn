cask "plover" do
  version "4.0.0"
  sha256 "48e1d2c1f32b411f09ced0b618fd9934d9429d74d36a2d417654487462ba97e2"

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
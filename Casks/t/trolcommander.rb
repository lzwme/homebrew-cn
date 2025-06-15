cask "trolcommander" do
  version "0.9.9"
  sha256 "143b62df9fa2ece807724b690692787cb10b3e42796faf6944f1f2d047db1d9e"

  url "https:github.comtrol73mucommanderreleasesdownloadv#{version}trolcommander-#{version.dots_to_underscores}.app.tar.gz?raw=true",
      verified: "github.comtrol73mucommander"
  name "trolCommander"
  desc "Fork of the muCommander file manager"
  homepage "https:trolsoft.ruensofttrolcommander"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-27", because: :unmaintained

  app "trolCommander.app"

  caveats do
    requires_rosetta
  end
end
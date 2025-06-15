cask "timestamp" do
  version "1.0.1"
  sha256 "b8062b283ed80f62267e50a4486a8610b7d59cd60d6697ad018c9aae97d478bb"

  url "https:github.commzdrtimestampreleasesdownload#{version}Timestamp-#{version}-mac.zip",
      verified: "github.commzdrtimestamp"
  name "Timestamp"
  desc "Improved clock for the menu bar"
  homepage "https:mzdr.github.iotimestamp"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-02-14", because: :discontinued
  disable! date: "2025-02-15", because: :discontinued

  app "Timestamp.app"

  caveats do
    requires_rosetta
  end
end
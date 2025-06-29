cask "play" do
  version "2.0.20"
  sha256 "101f1392bc03ece2ee6e86683472f33e3ebe0b91a050b41ed121d09253df930c"

  url "https:github.compmsaue0playreleasesdownloadv#{version}play_#{version}.dmg.zip",
      verified: "github.compmsaue0play"
  name "Play"
  homepage "https:pmsaue0.github.ioplay"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-07-28", because: :discontinued

  app "Play.app"

  zap trash: [
    "~LibraryApplication SupportPlay",
    "~LibraryCachesPlay",
  ]

  caveats do
    requires_rosetta
  end
end
cask "mirrordisplays" do
  version "1.2"
  sha256 "68b6b9a0bd79945d0e1239f308520a6cfd582fdde4dd061195de888b41643dd5"

  url "https:github.comfcanasmirror-displaysreleasesdownloadv#{version}MirrorDisplays.zip",
      verified: "github.comfcanasmirror-displays"
  name "Mirror Displays"
  homepage "https:fabiancanas.comopen-sourcemirror-displays"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-27", because: :unmaintained

  depends_on macos: ">= :high_sierra"

  app "MirrorDisplays.app"

  caveats do
    requires_rosetta
  end
end
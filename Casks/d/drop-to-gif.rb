cask "drop-to-gif" do
  version "1.28"
  sha256 "e4814912d1054f9d1c56357d10480ffb59996e59a54b969b45b2d01835fdc707"

  url "https:github.commortenjustdroptogifreleasesdownload#{version}Drop.to.GIF#{version.no_dots}.zip",
      verified: "github.commortenjustdroptogif"
  name "Drop to GIF"
  desc "Zero-click animated Gifs"
  homepage "https:mortenjust.github.iodroptogif"

  app "Drop to GIF.app"

  zap trash: [
    "~LibraryPreferencescom.mortenjust.Drop-to-GIF.plist",
    "~LibrarySaved Application Statecom.mortenjust.Drop-to-GIF.savedState",
  ]
end
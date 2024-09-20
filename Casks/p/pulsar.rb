cask "pulsar" do
  arch arm: "Silicon", intel: "Intel"
  arch_suffix = on_arch_conditional arm: "-arm64"

  version "1.121.0"
  sha256 arm:   "bb59cf9c6bca7f37350b007c609430464da15b7885fee99a492ca8fbf2a6b127",
         intel: "b1a9d01129ca7da534284b11435b4d20c2dbf1853174c919c4d8361c9b99adbb"

  url "https:github.compulsar-editpulsarreleasesdownloadv#{version}#{arch}.Mac.Pulsar-#{version}#{arch_suffix}-mac.zip",
      verified: "github.compulsar-editpulsar"
  name "Pulsar"
  desc "Text editor"
  homepage "https:pulsar-edit.dev"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Pulsar.app"
  binary "#{appdir}Pulsar.appContentsResourcesappppmbinapm", target: "ppm"
  binary "#{appdir}Pulsar.appContentsResourcespulsar.sh", target: "pulsar"

  zap trash: [
    "~.pulsar",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsdev.pulsar-edit.pulsar.sfl*",
    "~LibraryApplication SupportPulsar",
    "~LibraryPreferencesdev.pulsar-edit.pulsar.plist",
    "~LibrarySaved Application Statedev.pulsar-edit.pulsar.savedState",
  ]
end
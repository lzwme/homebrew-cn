cask "pulsar" do
  arch arm: "Silicon", intel: "Intel"
  arch_suffix = on_arch_conditional arm: "-arm64"

  version "1.127.0"
  sha256 arm:   "71d581f40cba76848ff88ec676d13a63135da7aba323e526b534822827d82435",
         intel: "ce663fc52037b724cb1b96ecf22006a0cb1e2bae89e6a559513ba3a738bd4683"

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
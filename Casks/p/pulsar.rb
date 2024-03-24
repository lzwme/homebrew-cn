cask "pulsar" do
  arch arm: "Silicon", intel: "Intel"
  arch_suffix = on_arch_conditional arm: "-arm64"

  version "1.115.0"
  sha256 arm:   "4f6a7880d478b52d7442dec81542c9f66c433a5bbd981a4283f3f9aa2487e2ff",
         intel: "1df1bfa39284a66ac2d7e79f098b11592febabaf1a01b69adfd4a73fd57af087"

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
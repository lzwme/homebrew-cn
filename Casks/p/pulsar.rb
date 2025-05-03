cask "pulsar" do
  arch arm: "Silicon", intel: "Intel"
  arch_suffix = on_arch_conditional arm: "-arm64"

  version "1.128.0"
  sha256 arm:   "0abd00f47e8ec0f3d41fe94ee7beb946c0d0e17138a890c77e20789f98534962",
         intel: "b0837864c1cf0e7b90e7951f376e422eda96b4390afa8c69fe70faa0e4275523"

  url "https:github.compulsar-editpulsarreleasesdownloadv#{version}#{arch}.Mac.Pulsar-#{version}#{arch_suffix}.dmg",
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
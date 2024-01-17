cask "pulsar" do
  arch arm: "Silicon", intel: "Intel"
  arch_suffix = on_arch_conditional arm: "-arm64"

  version "1.113.0"
  sha256 arm:   "747395a9e45846de82781d4fc6cdaeeb97b2d9ab5405cfed3bab2c7947acd09f",
         intel: "7d908edc8dec2fb27a923824af56aa5e5f8c761a81b819adc15664057214cdff"

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
cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.25.0"
  sha256 arm:   "b65e0d0a795dac7deeb0bb4547e46a585d9df4f95bf6f2ef654428ab31237ad9",
         intel: "b3a4586df03e5a45af7c2eeebb63fba2eeb08373374189c3adf51212210a2e62"

  url "https:github.comkinvolkheadlampreleasesdownloadv#{version}Headlamp-#{version}-mac-#{arch}-1.dmg",
      verified: "github.comkinvolkheadlamp"
  name "Headlamp"
  desc "UI for Kubernetes"
  homepage "https:kinvolk.github.ioheadlamp"

  app "Headlamp.app"

  uninstall quit: "com.kinvolk.headlamp"

  zap trash: [
    "~LibraryApplication SupportHeadlamp",
    "~LibraryLogsHeadlamp",
    "~LibraryPreferencescom.kinvolk.headlamp.plist",
  ]
end
cask "headlamp" do
  arch arm: "arm64", intel: "x64"

  version "0.24.0"
  sha256 arm:   "55d3afd26f685f069b905706dd1c9c8dc3a12aa9a98c4d6c94880d058eb682ee",
         intel: "5ad17025029de51e314e94a9a62e56f44974415176828edcd3bea02eb671b6bf"

  url "https:github.comkinvolkheadlampreleasesdownloadv#{version}Headlamp-#{version}-mac-#{arch}.dmg",
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
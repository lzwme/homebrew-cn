cask "agentkube" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.4"
  sha256 arm:   "8afb8b9aa6fa9d13cc7e8018c0ff836600f5b08e57fc50305a592ffc63098373",
         intel: "8bd840ccfaaf884517bdf6c40b49bfd9263f5025d40787a3e78975607e2a2fd5"

  url "https:github.comagentkubeagentkubereleasesdownloadv#{version}agentkube_#{version}_#{arch}-apple-darwin.tar.gz",
      verified: "github.comagentkubeagentkube"
  name "Agentkube"
  desc "AI-powered Kubernetes IDE"
  homepage "https:agentkube.com"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Agentkube.app"

  zap trash: [
    "~.agentkube",
    "~LibraryApplication Supportagentkube",
    "~LibraryLogsagentkube.log",
    "~LibraryPreferencesagentkube.plist",
    "~LibrarySaved Application Statecom.agentkube.app.savedState",
  ]
end
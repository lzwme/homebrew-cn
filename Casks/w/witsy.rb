cask "witsy" do
  arch arm: "arm64", intel: "x64"

  version "2.9.1"
  sha256 arm:   "efd75007910b25ae3d8368c5b41b033d7c23f9197035426123c19c452065c076",
         intel: "e3221fc8bfe92d32870f15abb4844aaa5559a75d7934c7073d1b779d3dc8bb13"

  url "https:github.comnbonamywitsyreleasesdownloadv#{version}Witsy-#{version}-darwin-#{arch}.dmg",
      verified: "github.comnbonamywitsy"
  name "Witsy"
  desc "BYOK (Bring Your Own Keys) AI assistant"
  homepage "https:witsyai.com"

  livecheck do
    url "https:update.electronjs.orgnbonamywitsydarwin-#{arch}0.0.0"
    strategy :json do |json|
      json["name"]
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Witsy.app"

  zap trash: [
    "~LibraryApplication SupportWitsy",
    "~LibraryLogsWitsy",
  ]
end
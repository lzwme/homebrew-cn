cask "witsy" do
  arch arm: "arm64", intel: "x64"

  version "2.7.1"
  sha256 arm:   "0bde6dfb220d3d7d2e74f614ac6a4aadabbaa6f85532498d353adc84ed704df6",
         intel: "8b505c9b51362250a59992bd5b696e928cfadbf2da3f86dd26253a82996318a8"

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
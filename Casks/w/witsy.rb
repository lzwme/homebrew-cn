cask "witsy" do
  arch arm: "arm64", intel: "x64"

  version "2.10.0"
  sha256 arm:   "82245d9dd78b7e3aca89d53ff885dd96108418c3cbdf226e0dc99b1b32210fbb",
         intel: "21fd424fc7313b327d75b83e769d283c4d0d6d126bfe4c48877465f4f3fcf3ed"

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
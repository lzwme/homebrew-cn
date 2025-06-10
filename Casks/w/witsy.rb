cask "witsy" do
  arch arm: "arm64", intel: "x64"

  version "2.8.1"
  sha256 arm:   "0c24d6c435091208b766e358f5c6b9c8ce02d4ceffecac5c396681cabe858f76",
         intel: "3dda889ade3da5d051582e4f43c70d2c59924c8dcd22dfe9ead98602bb12d32a"

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
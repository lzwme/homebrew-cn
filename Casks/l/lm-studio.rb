cask "lm-studio" do
  version "0.3.28,2"
  sha256 "eecc61299c192b30365543c7b02860cacc57301ed228477dccae2420f6d6623a"

  url "https://installers.lmstudio.ai/darwin/arm64/#{version.tr(",", "-")}/LM-Studio-#{version.tr(",", "-")}-arm64.dmg"
  name "LM Studio"
  desc "Discover, download, and run local LLMs"
  homepage "https://lmstudio.ai/"

  livecheck do
    url "https://versions-prod.lmstudio.ai/update/darwin/arm64/#{version.csv.first}"
    strategy :json do |json|
      version = json["version"]
      build = json["build"]
      next if version.blank? || build.blank?

      "#{version},#{build}"
    end
  end

  auto_updates true
  depends_on arch: :arm64

  app "LM Studio.app"

  uninstall quit: [
    "ai.elementlabs.lmstudio",
    "ai.elementlabs.lmstudio.helper",
  ]

  zap trash: [
    "~/Library/Application Support/LM Studio",
    "~/Library/Caches/ai.elementlabs.lmstudio",
    "~/Library/Caches/ai.elementlabs.lmstudio.ShipIt",
    "~/Library/HTTPStorages/ai.elementlabs.lmstudio",
    "~/Library/Logs/LM Studio",
    "~/Library/Preferences/ai.elementlabs.lmstudio.plist",
    "~/Library/Saved Application State/ai.elementlabs.lmstudio.savedState",
  ]
end
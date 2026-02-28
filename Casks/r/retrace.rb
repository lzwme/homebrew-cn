cask "retrace" do
  version "0.7.6"
  sha256 "43f0e588ba995079c6cd3ab8b350da32f7eaf9342954c719d5604c37ef93d1af"

  url "https://cdn.retrace.to/Retrace-v#{version}.dmg"
  name "Retrace"
  desc "Local-first screen recording and search application"
  homepage "https://retrace.to/"

  livecheck do
    url "https://retrace.to/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"
  depends_on arch: :arm64

  app "Retrace.app"

  zap trash: [
    "~/Library/Application Support/Retrace",
    "~/Library/Caches/io.retrace.app",
    "~/Library/HTTPStorages/io.retrace.app",
    "~/Library/Preferences/io.retrace.app.plist",
    "~/Library/Saved Application State/io.retrace.app.savedState",
  ]
end
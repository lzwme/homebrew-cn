cask "elk" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.4.0"
  sha256 arm:   "bfa8cf1854302eeb4f8f4ac28240b32ca674e2066bb29f518226b4fe93ecc4f0",
         intel: "e358c071ba8b310bdc29441f18fe56d6e31d96a5975c6f82be1088b10f1fbad9"

  url "https://ghfast.top/https://github.com/elk-zone/elk-native/releases/download/elk-native-v#{version}/Elk_#{version}_macos_#{arch}.dmg"
  name "Elk Native"
  desc "Mastodon web client"
  homepage "https://github.com/elk-zone/elk-native"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-04-11", because: :unmaintained
  disable! date: "2025-04-22", because: :unmaintained

  app "Elk.app"

  zap trash: [
    "~/Library/Application Support/zone.elk.native",
    "~/Library/Caches/zone.elk.native",
    "~/Library/HTTPStorages/zone.elk.native.binarycookies",
    "~/Library/Logs/zone.elk.native",
    "~/Library/Saved Application State/zone.elk.native.savedState",
    "~/Library/WebKit/zone.elk.native",
  ]
end
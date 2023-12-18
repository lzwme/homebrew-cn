cask "elk" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.4.0"
  sha256 arm:   "bfa8cf1854302eeb4f8f4ac28240b32ca674e2066bb29f518226b4fe93ecc4f0",
         intel: "e358c071ba8b310bdc29441f18fe56d6e31d96a5975c6f82be1088b10f1fbad9"

  url "https:github.comelk-zoneelk-nativereleasesdownloadelk-native-v#{version}Elk_#{version}_macos_#{arch}.dmg"
  name "Elk Native"
  desc "Mastodon web client"
  homepage "https:github.comelk-zoneelk-native"

  livecheck do
    url :url
    regex(elk[._-]native[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  app "Elk.app"

  zap trash: [
    "~LibraryApplication Supportzone.elk.native",
    "~LibraryCacheszone.elk.native",
    "~LibraryHTTPStorageszone.elk.native.binarycookies",
    "~LibraryLogszone.elk.native",
    "~LibrarySaved Application Statezone.elk.native.savedState",
    "~LibraryWebKitzone.elk.native",
  ]
end
cask "godot" do
  version "4.4"
  sha256 "7d184d3121e33abd1668a4e79ccda0242e04d5f6ad7b985c33b0c05c9a80cae1"

  url "https:github.comgodotenginegodotreleasesdownload#{version}-stableGodot_v#{version}-stable_macos.universal.zip",
      verified: "github.comgodotenginegodot"
  name "Godot Engine"
  desc "Game development engine"
  homepage "https:godotengine.org"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)[._-]stable$i)
    strategy :github_latest
  end

  conflicts_with cask: "godot@3"
  depends_on macos: ">= :high_sierra"

  app "Godot.app"
  binary "#{appdir}Godot.appContentsMacOSGodot", target: "godot"

  uninstall quit: "org.godotengine.godot"

  zap trash: [
    "~LibraryApplication SupportGodot",
    "~LibraryCachesGodot",
    "~LibrarySaved Application Stateorg.godotengine.godot.savedState",
  ]
end
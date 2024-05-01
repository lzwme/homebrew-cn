cask "godot" do
  version "4.2.2"
  sha256 "57646027e4b304dc65570b3f29d78a7eefa862e287d4e99f432bc381143d1ec5"

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
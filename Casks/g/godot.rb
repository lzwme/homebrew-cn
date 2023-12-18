cask "godot" do
  version "4.2.1"
  sha256 "7426f9ea843643ad51776a456d918604123104cfc2b4ba71c9ac6ac55a4b7d75"

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

  conflicts_with cask: "homebrewcask-versionsgodot3"
  depends_on macos: ">= :sierra"

  app "Godot.app"
  binary "#{appdir}Godot.appContentsMacOSGodot", target: "godot"

  uninstall quit: "org.godotengine.godot"

  zap trash: [
    "~LibraryApplication SupportGodot",
    "~LibraryCachesGodot",
    "~LibrarySaved Application Stateorg.godotengine.godot.savedState",
  ]
end
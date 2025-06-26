cask "godot@3" do
  version "3.6.1"
  sha256 "5f3744623f92205ae2cdd1df123bbfbb4dae864837ddfc2d04df7a3167b503fa"

  url "https:github.comgodotenginegodotreleasesdownload#{version}-stableGodot_v#{version}-stable_osx.universal.zip",
      verified: "github.comgodotenginegodot"
  name "Godot Engine"
  desc "Game development engine"
  homepage "https:godotengine.org"

  livecheck do
    url :url
    regex(^v?(3(?:\.\d+)+)[._-]stable$i)
  end

  no_autobump! because: :requires_manual_review

  conflicts_with cask: "godot"
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
cask "godot@3" do
  version "3.5.3"
  sha256 "d448bf70a438edfd506c6878963327d7814d83fd636d132294fb7abb1f971246"

  url "https:downloads.tuxfamily.orggodotengine#{version}Godot_v#{version}-stable_osx.universal.zip",
      verified: "downloads.tuxfamily.orggodotengine"
  name "Godot Engine"
  desc "Game development engine"
  homepage "https:godotengine.org"

  livecheck do
    url "https:github.comgodotenginegodot"
    regex(^v?(3(?:\.\d+)+)[._-]stable$i)
  end

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
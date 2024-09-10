cask "godot@3" do
  version "3.6"
  sha256 "00cc8c8708756ad336d36bbfafd0cb6becd61e5b8e7d826309a3f4d5dda2c275"

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
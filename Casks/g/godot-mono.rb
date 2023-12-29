cask "godot-mono" do
  version "4.2.1"
  sha256 "b0b4924f715cdf6b1cdabd97f3509cf4252a5f5226c537740d6e109e92c141ce"

  url "https:github.comgodotenginegodotreleasesdownload#{version}-stableGodot_v#{version}-stable_mono_macos.universal.zip",
      verified: "github.comgodotenginegodot"
  name "Godot Engine"
  desc "C# scripting capable version of Godot game engine"
  homepage "https:godotengine.org"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)[._-]stable$i)
    strategy :github_latest
  end

  depends_on cask: "dotnet-sdk"
  depends_on macos: ">= :sierra"

  app "Godot_mono.app"
  binary "#{appdir}Godot_mono.appContentsMacOSGodot", target: "godot-mono"

  uninstall quit: "org.godotengine.godot"

  zap trash: [
    "~LibraryApplication SupportGodot",
    "~LibraryCachesGodot",
    "~LibrarySaved Application Stateorg.godotengine.godot.savedState",
  ]
end
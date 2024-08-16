cask "godot-mono" do
  version "4.3"
  sha256 "115ec67929a5e9a55cba1b4f578ddf8cfc6003e2eb1406e5a484d63ab53b03b7"

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
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}godot-mono.wrapper.sh"
  binary shimscript, target: "godot-mono"

  preflight do
    File.write shimscript, <<~EOS
      #!binbash
      '#{appdir}Godot_mono.appContentsMacOSGodot' "$@"
    EOS
  end

  uninstall quit: "org.godotengine.godot"

  zap trash: [
    "~LibraryApplication SupportGodot",
    "~LibraryCachesGodot",
    "~LibrarySaved Application Stateorg.godotengine.godot.savedState",
  ]
end
cask "godot-mono" do
  version "4.4.1"
  sha256 "325be823284ce491487a69b354dbb481875857bee84a0b1d00c2552cea92c0a7"

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
cask "godot-mono" do
  version "4.5"
  sha256 "0a963afd43d26231c0fe0d575c1179dac7f000d76e4df9704679245fcc4f340e"

  url "https://ghfast.top/https://github.com/godotengine/godot/releases/download/#{version}-stable/Godot_v#{version}-stable_mono_macos.universal.zip",
      verified: "github.com/godotengine/godot/"
  name "Godot Engine"
  desc "C# scripting capable version of Godot game engine"
  homepage "https://godotengine.org/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)[._-]stable$/i)
    strategy :github_latest
  end

  depends_on cask: "dotnet-sdk"

  app "Godot_mono.app"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/godot-mono.wrapper.sh"
  binary shimscript, target: "godot-mono"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/bash
      '#{appdir}/Godot_mono.app/Contents/MacOS/Godot' "$@"
    EOS
  end

  uninstall quit: "org.godotengine.godot"

  zap trash: [
    "~/Library/Application Support/Godot",
    "~/Library/Caches/Godot",
    "~/Library/Saved Application State/org.godotengine.godot.savedState",
  ]
end
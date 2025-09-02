cask "tiled" do
  version "1.11.2"

  on_catalina :or_older do
    sha256 "779bf4e4f598933014e08a4e48297a918e4a8847b749147fed803884377c3091"

    url "https://ghfast.top/https://github.com/mapeditor/tiled/releases/download/v#{version}/Tiled-#{version}_macOS-10.12-10.15.zip",
        verified: "github.com/mapeditor/tiled/"
  end
  on_big_sur :or_newer do
    sha256 "1170faae26789569ac9c6ff9a176e0cc1c3a6c3beecf148f9c91760fd3b72bb5"

    url "https://ghfast.top/https://github.com/mapeditor/tiled/releases/download/v#{version}/Tiled-#{version}_macOS-11+.zip",
        verified: "github.com/mapeditor/tiled/"
  end

  name "Tiled"
  desc "Flexible level editor"
  homepage "https://www.mapeditor.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "Tiled.app"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/tiled.wrapper.sh"
  binary shimscript, target: "tiled"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/bash
      exec '#{appdir}/Tiled.app/Contents/MacOS/Tiled' "$@"
    EOS
  end

  zap trash: [
    "~/Library/Application Support/Tiled",
    "~/Library/Preferences/org.mapeditor.Tiled.plist",
    "~/Library/Preferences/Tiled",
  ]
end
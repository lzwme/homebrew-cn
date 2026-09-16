cask "legacy-clonk" do
  version "365"
  sha256 "654498bfa8f5b029b4058cc3fb128d5a2b53c6a85d28328ad831aa2ad0e7693a"

  url "https://ghfast.top/https://github.com/legacyclonk/LegacyClonk/releases/download/v#{version}/LegacyClonk-Mac-universal.zip"
  name "LegacyClonk"
  desc "2D Action Adventure Game"
  homepage "https://clonkspot.org/lc-en"

  livecheck do
    url :stable
  end

  depends_on :macos

  app "clonk.app", target: "LegacyClonk/clonk.app"
  binary "c4group"

  postflight_steps do
    run "/bin/sh", args:           ["-c", <<~SHELL],
      set -eu -o pipefail
      cd "{{appdir}}/LegacyClonk"
      /usr/bin/curl --fail --location --output Graphics.c4g \
        "https://ghfast.top/https://github.com/legacyclonk/LegacyClonk/releases/download/v{{version}}/Graphics.c4g"
      echo "4146962f4201f7ed7b504ae8332dc5c4c3b4303d5fc4aca3ad02c77e4c3fbae3  Graphics.c4g" \
        | /usr/bin/shasum --check --status -
    SHELL
                   network_access: true,
                   writable_paths: ["{{appdir}}/LegacyClonk"]
    run "/bin/sh", args:           ["-c", <<~SHELL],
      set -eu -o pipefail
      cd "{{appdir}}/LegacyClonk"
      /usr/bin/curl --fail --location --output System.c4g \
        "https://ghfast.top/https://github.com/legacyclonk/LegacyClonk/releases/download/v{{version}}/System.c4g"
      echo "d91d9f0c9b56f0ca89ad8810971cbd427ee3391a4f75a841ee58c7aa52c3a478  System.c4g" \
        | /usr/bin/shasum --check --status -
    SHELL
                   network_access: true,
                   writable_paths: ["{{appdir}}/LegacyClonk"]
  end

  uninstall quit:  "#{appdir}/LegacyClonk/clonk.app",
            trash: [
              "#{appdir}/Clonk.log",
              "#{appdir}/LegacyClonk/Graphics.c4g",
              "#{appdir}/LegacyClonk/System.c4g",
            ],
            rmdir: "#{appdir}/LegacyClonk"

  zap trash: [
    "#{appdir}/LegacyClonk",
    "/Library/Logs/DiagnosticReports/clonk_*.diag",
    "~/Library/Logs/DiagnosticReports/clonk_*.diag",
    "~/Library/Logs/Homebrew/clonk-rage",
  ]

  caveats do
    requires_rosetta
    unsigned_accessibility
  end
end
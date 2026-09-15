cask "legacy-clonk" do
  version "365"
  sha256 "5cfdd3d13f2905bee8dde5ceb56e55c55ba08da57729cc23848d63fcbd900137"

  url "https://ghfast.top/https://github.com/legacyclonk/LegacyClonk/releases/download/v#{version}/LegacyClonk-Mac-x64.zip"
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
      /usr/bin/curl --fail --location --output "{{appdir}}/LegacyClonk/Graphics.c4g" \
        "https://ghfast.top/https://github.com/legacyclonk/LegacyClonk/releases/download/v{{version}}/Graphics.c4g"
      echo "a064b2ee144ebfe100fa652e36e6f892c745aa2fc28f8cd596f9711aa5d1c835  Graphics.c4g" \
        | /usr/bin/shasum --check --status -
    SHELL
                   network_access: true,
                   writable_paths: ["{{appdir}}/LegacyClonk"]
    run "/bin/sh", args:           ["-c", <<~SHELL],
      set -eu -o pipefail
      /usr/bin/curl --fail --location --output "{{appdir}}/LegacyClonk/System.c4g" \
        "https://ghfast.top/https://github.com/legacyclonk/LegacyClonk/releases/download/v{{version}}/System.c4g"
      echo "efe00042285f7d49935c4f9724d0068caf489d4ca93bfbe4f7790cf345dcc8a4  System.c4g" \
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
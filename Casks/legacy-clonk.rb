cask "legacy-clonk" do
  version "363"
  sha256 "5cfdd3d13f2905bee8dde5ceb56e55c55ba08da57729cc23848d63fcbd900137"

  url "https://ghfast.top/https://github.com/legacyclonk/LegacyClonk/releases/download/v#{version}/LegacyClonk-Mac-x64.zip",
      verified: "github.com/legacyclonk/LegacyClonk/"
  name "LegacyClonk"
  desc "2D Action Adventure Game"
  homepage "https://clonkspot.org/lc-en"

  livecheck do
    url :stable
  end

  app "clonk.app", target: "LegacyClonk/clonk.app"
  binary "c4group"

  postflight do
    cask = @cask
    (appdir / "LegacyClonk").install(Resource.new("Graphics.c4g") do
      url "https://ghfast.top/https://github.com/legacyclonk/LegacyClonk/releases/download/v#{cask.version}/Graphics.c4g"
      sha256 "a064b2ee144ebfe100fa652e36e6f892c745aa2fc28f8cd596f9711aa5d1c835"
    end)
    (appdir / "LegacyClonk").install(Resource.new("System.c4g") do
      url "https://ghfast.top/https://github.com/legacyclonk/LegacyClonk/releases/download/v#{cask.version}/System.c4g"
      sha256 "efe00042285f7d49935c4f9724d0068caf489d4ca93bfbe4f7790cf345dcc8a4"
    end)
  end

  uninstall_postflight do
    (appdir / "LegacyClonk").rmdir_if_possible
  end

  uninstall quit:  "#{appdir}/LegacyClonk/clonk.app",
            trash: [
              "#{appdir}/Clonk.log",
              "#{appdir}/LegacyClonk/Graphics.c4g",
              "#{appdir}/LegacyClonk/System.c4g",
            ]

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
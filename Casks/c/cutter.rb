cask "cutter" do
  arch arm: "arm64", intel: "x86_64"

  version "2.4.0"
  sha256 arm:   "85be3bf6b0b62199c2027fecf5deb5753001eda5551297741524e2d88ae1780b",
         intel: "03250a816652f98dba7f2d1dd751e74ba457ecbfb7c9b7a37034c50769d89bd6"

  url "https:github.comrizinorgcutterreleasesdownloadv#{version}Cutter-v#{version}-macOS-#{arch}.dmg",
      verified: "github.comrizinorgcutter"
  name "Cutter"
  desc "Reverse engineering platform powered by Rizin"
  homepage "https:cutter.re"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "Cutter.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}cutter.wrapper.sh"
  binary shimscript, target: "cutter"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      '#{appdir}Cutter.appContentsMacOSCutter' "$@"
    EOS
  end

  zap trash: [
    "~.configrizin",
    "~.localsharerizin",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsre.rizin.cutter.sfl*",
    "~LibraryApplication Supportrizin",
    "~LibraryPreferencesre.rizin.cutter.plist",
    "~LibrarySaved Application Statere.rizin.cutter.savedState",
  ]
end
cask "cutter" do
  arch arm: "arm64", intel: "x86_64"

  version "2.3.3"
  sha256 arm:   "7e690c327043af83554d8b1a35f51b788c5d1b3e2f46f1594a20cb187ec319c1",
         intel: "1a9b0a0fd46845396b519b40615dce7d4ec70c85992ec14b003b398a38605582"

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
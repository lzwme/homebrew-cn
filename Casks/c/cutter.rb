cask "cutter" do
  arch arm: "arm64", intel: "x86_64"

  version "2.3.2"
  sha256 arm:   "19027e6c6515d588d6d0cb7ab5506828247f98b1ee80c7c3b1c6354d1ca25dcf",
         intel: "22ad2f3cec9cffefc8de9129c311a8f5412a641322127c43e05cef2bd498782f"

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
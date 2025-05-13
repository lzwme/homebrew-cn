cask "cutter" do
  arch arm: "arm64", intel: "x86_64"

  version "2.4.1"
  sha256 arm:   "172d364bb4d3bdbd7cedc12f32721003b3630536a96d1e6c382d9a453f483ea9",
         intel: "b88d772cbcce0186d36beca0e49ec58573e8c1d9af4be77dc3225467748f29ab"

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
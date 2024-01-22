cask "vlc" do
  arch arm: "arm64", intel: "intel64"

  version "3.0.20"
  sha256 arm:   "5d5f0ee52d81982a622f4021928a64b4705a9554499e20c33d0bac22590b118e",
         intel: "a4dc1441fcab8e2b90c62974ce5399bb88acbf6c70d54f21c6158d9fb1fba279"

  url "https:get.videolan.orgvlc#{version}macosxvlc-#{version}-#{arch}.dmg"
  name "VLC media player"
  desc "Multimedia player"
  homepage "https:www.videolan.orgvlc"

  livecheck do
    url "https:www.videolan.orgvlcdownload-macosx.html"
    regex(%r{href=.*?vlc[._-]v?(\d+(?:\.\d+)+)(?:[._-][a-z]\w*)?\.dmg}i)
  end

  auto_updates true
  conflicts_with cask: "homebrewcask-versionsvlc-nightly"

  app "VLC.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}vlc.wrapper.sh"
  binary shimscript, target: "vlc"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}VLC.appContentsMacOSVLC' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.videolan.vlc.sfl*",
    "~LibraryApplication Supportorg.videolan.vlc",
    "~LibraryApplication SupportVLC",
    "~LibraryCachesorg.videolan.vlc",
    "~LibraryHTTPStoragesorg.videolan.vlc",
    "~LibraryPreferencesorg.videolan.vlc",
    "~LibraryPreferencesorg.videolan.vlc.plist",
    "~LibrarySaved Application Stateorg.videolan.vlc.savedState",
  ]
end
cask "vlc-nightly" do
  arch arm: "arm64", intel: "x86_64"

  version :latest
  sha256 :no_check

  url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}" do |page|
    folder_path = page[%r{\d+-\d+}]
    url URI.join(page.url, folder_path) do |version_page|
      file_path = version_page[href="([^"]+.dmg)", 1]
      URI.join(version_page.url, file_path)
    end
  end
  name "VLC media player"
  desc "Open-source cross-platform multimedia player"
  homepage "https:www.videolan.orgvlc"

  conflicts_with cask: "vlc"

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
    "~LibraryPreferencesorg.videolan.vlc",
    "~LibraryPreferencesorg.videolan.vlc.plist",
    "~LibrarySaved Application Stateorg.videolan.vlc.savedState",
  ]
end
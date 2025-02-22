cask "vuze" do
  version "5.7.7.0"
  sha256 :no_check

  url "https://cf1.vuze.com/files/J7/VuzeBittorrentClientInstaller.dmg"
  name "Vuze"
  desc "Bit torrent client"
  homepage "https://www.vuze.com/"

  livecheck do
    url :url
    strategy :extract_plist
  end

  installer script: {
    executable: "Vuze Installer.app/Contents/MacOS/JavaApplicationStub",
    args:       ["-q"],
    sudo:       true,
  }

  uninstall quit:   "com.azureus.vuze",
            delete: [
              "/Applications/Uninstaller for Vuze.app",
              "/Applications/Vuze.app",
            ]

  zap trash: "~/Library/Application Support/Vuze"
end
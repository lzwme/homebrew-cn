cask "ppsspp" do
  version "1.16.6"
  sha256 "3ddb393885303b43e886c898a78bd81fafb022a96a5dccdab4462617f344835a"

  url "https:github.comhrydgardppssppreleasesdownloadv#{version}PPSSPPSDL-macOS-v#{version}.zip",
      verified: "github.comhrydgardppsspp"
  name "PPSSPP"
  desc "PSP emulator"
  homepage "https:www.ppsspp.org"

  app "PPSSPPSDL.app"

  uninstall quit: "org.ppsspp.ppsspp"

  zap trash: "~.configppsspp"
end
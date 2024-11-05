cask "ppsspp" do
  version "1.18.1"
  sha256 "6926796c544464ce28691d099c71861d29967366542a4b37c6e60575ec782b3f"

  url "https:github.comhrydgardppssppreleasesdownloadv#{version}PPSSPPSDL-macOS-v#{version}.zip",
      verified: "github.comhrydgardppsspp"
  name "PPSSPP"
  desc "PSP emulator"
  homepage "https:www.ppsspp.org"

  app "PPSSPPSDL.app"

  uninstall quit: "org.ppsspp.ppsspp"

  zap trash: "~.configppsspp"
end
cask "ppsspp" do
  version "1.17.1"
  sha256 "b0b2e1ea7c2e00690e41cd0fafef2ebed39d072c933443b571389f2620763ff1"

  url "https:github.comhrydgardppssppreleasesdownloadv#{version}PPSSPPSDL-macOS-v#{version}.zip",
      verified: "github.comhrydgardppsspp"
  name "PPSSPP"
  desc "PSP emulator"
  homepage "https:www.ppsspp.org"

  app "PPSSPPSDL.app"

  uninstall quit: "org.ppsspp.ppsspp"

  zap trash: "~.configppsspp"
end
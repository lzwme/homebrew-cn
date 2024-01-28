cask "ppsspp" do
  version "1.17"
  sha256 "5ab391ae77069d36d74486eb1444ce9dff9f5f1324813325a2c2678ef4663d0c"

  url "https:github.comhrydgardppssppreleasesdownloadv#{version}PPSSPPSDL-macOS-v#{version}.zip",
      verified: "github.comhrydgardppsspp"
  name "PPSSPP"
  desc "PSP emulator"
  homepage "https:www.ppsspp.org"

  app "PPSSPPSDL.app"

  uninstall quit: "org.ppsspp.ppsspp"

  zap trash: "~.configppsspp"
end
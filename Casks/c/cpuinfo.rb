cask "cpuinfo" do
  version "1.5.1"
  sha256 "e6037c41db55d6032bfb0c5f6ed6b62d8303a58b1a13a972522253aeebef427a"

  url "https:github.comyusukeshibatacpuinforaw#{version}distcpuinfo.zip"
  name "cpuinfo"
  desc "CPU meter menu bar app"
  homepage "https:github.comyusukeshibatacpuinfo"

  no_autobump! because: :requires_manual_review

  app "cpuinfo.app"

  zap trash: [
    "~LibraryApplication Scriptsio.fata.shibata.cpuinfo",
    "~LibraryContainersio.fata.shibata.cpuinfo",
  ]
end
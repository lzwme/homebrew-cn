cask "warcraft-logs-uploader" do
  version "8.5.38"
  sha256 "6e5fc4a7f90dbd5723f0d2dcdf7fe705ddd78c2fdcaba90ae428df8919c0fe7e"

  url "https:github.comRPGLogsUploaders-warcraftlogsreleasesdownloadv#{version}warcraftlogs-v#{version}.dmg",
      verified: "github.comRPGLogsUploaders-warcraftlogs"
  name "Warcraft Logs Uploader"
  desc "Client to upload warcraft logs"
  homepage "https:classic.warcraftlogs.com"

  livecheck do
    url "https:classic.warcraftlogs.comclientdownload"
    regex(%r{.*?warcraftlogs[._-]v?(\d+(?:\.\d+)+)\.dmg}i)
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Warcraft Logs Uploader.app"

  zap trash: "~LibraryApplication SupportWarcraft Logs Uploader"
end
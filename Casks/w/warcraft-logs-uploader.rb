cask "warcraft-logs-uploader" do
  version "8.12.39"
  sha256 "1f7de548fabc21a9ab98205139774912903f8db7d2aa1598a22ffa4c49a909a5"

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
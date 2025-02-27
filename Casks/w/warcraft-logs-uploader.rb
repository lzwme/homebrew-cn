cask "warcraft-logs-uploader" do
  version "8.16.2"
  sha256 "504a429d2f6054191fe06ff98a5bceaed691a1bb9d4dbd60092eff895579d13b"

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
  depends_on macos: ">= :catalina"

  app "Warcraft Logs Uploader.app"

  zap trash: "~LibraryApplication SupportWarcraft Logs Uploader"
end
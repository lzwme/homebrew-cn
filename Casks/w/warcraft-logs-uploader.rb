cask "warcraft-logs-uploader" do
  version "8.13.5"
  sha256 "b7f36af5ab053a87205069a5b8b8400ee1c01af621e8b7673ca88cb87767d2f4"

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
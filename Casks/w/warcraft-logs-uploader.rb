cask "warcraft-logs-uploader" do
  version "8.5.12"
  sha256 "568bc2995d41e84f30f0246477726bee024e9157477a512727d1817789bed275"

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
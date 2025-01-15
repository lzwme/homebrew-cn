cask "noti" do
  version "0.3.2"
  sha256 "3ad018a37b2a16f019aac3680fd83ae6e5580a5548210179d305cdbf330eedad"

  url "https:github.comjarizNotireleasesdownload#{version}Noti.dmg",
      verified: "github.comjarizNoti"
  name "Noti"
  desc "Utility to show notifications from an Android device"
  homepage "https:noti.center"

  deprecate! date: "2024-01-13", because: :discontinued
  disable! date: "2025-01-14", because: :discontinued

  auto_updates true

  app "Noti.app"
end
cask "airunlock" do
  version "0.4"
  sha256 "85f4aee6bc67f6b7c0d01ab36e50a117690574c0e31b210aa3f80931269bf170"

  url "https://ghfast.top/https://github.com/pinetum/AirUnlock-for-Mac/releases/download/#{version}/AirUnlock_mac_#{version}.zip"
  name "AirUnlock"
  desc "Tool to lock or unlock the macbook using an Android phone via Bluetooth"
  homepage "https://github.com/pinetum/AirUnlock-for-Mac"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "AirUnlock.app"
end
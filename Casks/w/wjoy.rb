cask "wjoy" do
  version "0.7.1"
  sha256 "98a9f825634b09b901ad979a6cdda241a04a1cbd7dcd14b4b17b0bebe3f40ee1"

  url "https://ghfast.top/https://github.com/alxn1/wjoy/releases/download/#{version}/wjoy.#{version}.dmg"
  name "WJoy"
  desc "Nintendo wiimote driver"
  homepage "https://github.com/alxn1/wjoy"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Wjoy.app"
end
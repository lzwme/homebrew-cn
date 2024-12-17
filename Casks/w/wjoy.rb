cask "wjoy" do
  version "0.7.1"
  sha256 "98a9f825634b09b901ad979a6cdda241a04a1cbd7dcd14b4b17b0bebe3f40ee1"

  url "https:github.comalxn1wjoyreleasesdownload#{version}wjoy.#{version}.dmg"
  name "WJoy"
  desc "Nintendo wiimote driver"
  homepage "https:github.comalxn1wjoy"

  disable! date: "2024-12-16", because: :discontinued

  app "Wjoy.app"
end
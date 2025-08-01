cask "multibit-hd" do
  version "0.5.1"
  sha256 "c79e4e315576db7152a139f2c35aa5b47bc706a3df9669bfddba9bdeb9db4520"

  url "https://ghfast.top/https://github.com/Multibit-Legacy/multibit-hd/releases/download/v#{version}/multibit-macos-#{version}-drag-install.dmg"
  name "MultiBit HD"
  homepage "https://github.com/Multibit-Legacy/multibit-hd"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "MultiBit HD.app"

  uninstall quit: "com.install4j.6925-4794-5772-4956.24"

  caveats do
    requires_rosetta
  end
end
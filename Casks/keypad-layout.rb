cask "keypad-layout" do
  version "1.10"
  sha256 "366a828fa327f18d0657ae8406147289ff03a07b70d79b3bdbfc5a61faa137c7"

  url "https://ghproxy.com/https://github.com/janten/keypad-layout/releases/download/#{version}/Keypad-Layout.zip"
  name "Keypad Layout"
  desc "Utility to control window layout using the Ctrl key and the numeric keypad"
  homepage "https://github.com/janten/keypad-layout"

  app "Keypad Layout.app"
end
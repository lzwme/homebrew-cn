cask "betelguese" do
  version "1.1"
  sha256 "ada42a23f280d5bb65a3708fb3e8da70026eef7ceee2653f8cdc75bf43b26097"

  url "https://ghfast.top/https://github.com/23Aaron/Betelguese/releases/download/#{version}/Betelguese.app.zip"
  name "Betelguese"
  desc "Odysseyra1n installer GUI for jailbroken devices"
  homepage "https://github.com/23Aaron/Betelguese"

  no_autobump! because: :requires_manual_review

  app "Betelguese.app"

  zap trash: "~/Library/Saved Application State/com.23aaron.Betelgeuse.savedState"
end
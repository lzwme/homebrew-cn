cask "betelguese" do
  version "1.1"
  sha256 "ada42a23f280d5bb65a3708fb3e8da70026eef7ceee2653f8cdc75bf43b26097"

  url "https://ghfast.top/https://github.com/23Aaron/Betelguese/releases/download/#{version}/Betelguese.app.zip"
  name "Betelguese"
  desc "Odysseyra1n installer GUI for jailbroken devices"
  homepage "https://github.com/23Aaron/Betelguese"

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Betelguese.app"

  zap trash: "~/Library/Saved Application State/com.23aaron.Betelgeuse.savedState"
end
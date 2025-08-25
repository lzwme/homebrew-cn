cask "cmd-eikana" do
  version "2.2.3"
  sha256 "8e4157304ae21566339e956423632d34aacd12c96e87f35ffc83bf2304ff9be4"

  url "https://ghfast.top/https://github.com/iMasanari/cmd-eikana/releases/download/v#{version}/eikana-#{version}.app.zip"
  name "Eikana"
  name "⌘英かな"
  homepage "https://github.com/iMasanari/cmd-eikana"

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "⌘英かな.app"

  zap trash: "~/Library/Preferences/io.github.imasanari.cmd-eikana.plist"

  caveats do
    requires_rosetta
  end
end
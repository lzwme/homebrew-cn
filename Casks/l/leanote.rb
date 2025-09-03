cask "leanote" do
  version "2.7.0"
  sha256 "18c680dc9f3af54a0ef4edfa987407ed41bbd4654bc1791720cb40e0047b3da4"

  url "https://ghfast.top/https://github.com/leanote/desktop-app/releases/download/v#{version}/leanote-desktop-mac-v#{version}.zip",
      verified: "github.com/leanote/desktop-app/"
  name "Leanote"
  desc "Open source cloud notepad"
  homepage "https://leanote.org/"

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Leanote.app"

  zap trash: [
    "~/Library/Application Support/leanote",
    "~/Library/Application Support/Leanote-Desktop",
  ]

  caveats do
    requires_rosetta
  end
end
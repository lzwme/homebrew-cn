cask "jitsi-meet" do
  version "2024.5.0"
  sha256 "aca0ba375095b282c724f4649c61be68f2dd76b2d45721d2e67871cf2d6e4a5c"

  url "https:github.comjitsijitsi-meet-electronreleasesdownloadv#{version}jitsi-meet.dmg"
  name "Jitsi Meet"
  desc "Secure video conferencing app"
  homepage "https:github.comjitsijitsi-meet-electron"

  auto_updates true

  app "Jitsi Meet.app"

  zap trash: [
    "~LibraryApplication SupportJitsi Meet",
    "~LibraryLogsJitsi Meet",
  ]
end
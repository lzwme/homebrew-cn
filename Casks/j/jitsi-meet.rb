cask "jitsi-meet" do
  version "2024.6.0"
  sha256 "d3c121e67342c16bac62d72c8e10a26542a80a7d3d8094a829a3b406e8bbdd33"

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
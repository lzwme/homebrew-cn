cask "jitsi-meet" do
  version "2023.11.3"
  sha256 "a550500386dd74019487e39df29299f355e71d1a6e9839208c64168967178971"

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
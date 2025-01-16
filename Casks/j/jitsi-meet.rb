cask "jitsi-meet" do
  version "2025.1.1"
  sha256 "c32378c375cb42e3aed980416c1c7fd937b7bf31bfa8f2bc13afc0c86d57d353"

  url "https:github.comjitsijitsi-meet-electronreleasesdownloadv#{version}jitsi-meet.dmg"
  name "Jitsi Meet"
  desc "Secure video conferencing app"
  homepage "https:github.comjitsijitsi-meet-electron"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Jitsi Meet.app"

  zap trash: [
    "~LibraryApplication SupportJitsi Meet",
    "~LibraryLogsJitsi Meet",
  ]
end
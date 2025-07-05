cask "gpg-sync" do
  version "0.3.6"
  sha256 "3517b53a9a8fd7312b6f5c7d5c425c9facc2cc6cbbadaabd2edb83e07c291c0d"

  url "https://ghfast.top/https://github.com/firstlookmedia/gpgsync/releases/download/v#{version}/GPGSync-#{version}.pkg"
  name "GPG Sync"
  homepage "https://github.com/firstlookmedia/gpgsync/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  pkg "GPGSync-#{version}.pkg"

  uninstall launchctl: "org.firstlook.gpgsync",
            pkgutil:   "org.firstlook.gpgsync"
end
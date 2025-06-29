cask "ckb-next" do
  version "0.4.4"
  sha256 "2a762181525ba4b1f26a95b374babe48ff0d590f1d36bc109749c845c8a57090"

  url "https:github.comckb-nextckb-nextreleasesdownloadv#{version}ckb-next_v#{version}.dmg"
  name "ckb-next"
  desc "RGB driver"
  homepage "https:github.comckb-nextckb-next"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :sierra"

  pkg "ckb-next.mpkg"

  uninstall launchctl: "org.ckb-next.daemon",
            pkgutil:   [
              "org.ckb-next.ckb",
              "org.ckb-next.daemon",
            ]
end
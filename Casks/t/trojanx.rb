cask "trojanx" do
  version "0.4"
  sha256 "794e02b6b530ea076b5fcc51061efb597cc4ff0a1d8064897bca16122f6fc798"

  url "https:github.comJimLee1996TrojanXreleasesdownload#{version}TrojanX.app.zip"
  name "TrojanX"
  desc "Mechanism to bypass the Great Firewall"
  homepage "https:github.comJimLee1996TrojanX"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-08-30", because: :unmaintained

  depends_on macos: ">= :el_capitan"

  app "TrojanX.app"

  uninstall delete: "LibraryApplication SupportTrojanX"

  zap trash: [
    "~.TrojanX",
    "~LibraryApplication SupportTrojanX",
    "~LibraryPreferencesTrojanX.plist",
  ]

  caveats do
    requires_rosetta
  end
end
cask "keymanager" do
  version "4.4.19"
  sha256 "fd41152f8897bfce5e6e95fc74c7aa3044a60266726d7b2dee0896901b02359b"

  url "https://keymanager.trustasia.com/release/KeyManager-#{version}.dmg",
      verified: "keymanager.trustasia.com/"
  name "KeyManager"
  desc "Certificate manager"
  homepage "https://keymanager.org/"

  livecheck do
    url "https://keymanager.org/release/latest.yml"
    strategy :electron_builder
  end

  app "KeyManager.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/keymanager.sfl*",
    "~/Library/Application Support/keymanager",
    "~/Library/Logs/keymanager",
    "~/Library/Preferences/keymanager.plist",
    "~/Library/Saved Application State/keymanager.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
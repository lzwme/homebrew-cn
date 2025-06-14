cask "emclient@beta" do
  version "10.0.2362"
  sha256 "7ba21c4bea1512e30ebf489f1d818c35d1d2ae43e144db63cc612ac7b78b694b"

  url "https://cdn-dist.emclient.com/dist/v#{version}_Mac/setup.pkg"
  name "eM Client"
  desc "Email client"
  homepage "https://www.emclient.com/"

  livecheck do
    url "https://www.emclient.com/dist/latest-beta-mac/"
    regex(/v?(\d+(?:\.\d+)+)[._-]Mac/i)
    strategy :header_match
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  conflicts_with cask: "emclient"
  depends_on macos: ">= :big_sur"

  pkg "setup.pkg"

  uninstall pkgutil: "com.emclient.mail.client.pkg",
            delete:  "/Applications/eM Client.app"

  zap trash: [
    "~/Library/Caches/com.emclient.mail.client",
    "~/Library/Preferences/com.emclient.mail.*.plist",
    "~/Library/Saved Application State/com.emclient.mail.client.savedState",
  ]
end
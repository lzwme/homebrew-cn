cask "emclient" do
  version "10.0.3123"
  sha256 "32c05463565cbf96cdda5856b93d0f6656abb7e7912c189172b00dc9059c8681"

  url "https://cdn-dist.emclient.com/dist/v#{version}_Mac/setup.pkg"
  name "eM Client"
  desc "Email client"
  homepage "https://www.emclient.com/"

  livecheck do
    url "https://www.emclient.com/dist/latest/setup.pkg"
    regex(/v?(\d+(?:\.\d+)+)[._-]Mac/i)
    strategy :header_match
  end

  auto_updates true
  conflicts_with cask: "emclient@beta"
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
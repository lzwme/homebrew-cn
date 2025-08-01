cask "heimdall-suite" do
  version "1.4.0"
  sha256 "4b283fc7bc331f8ec84031c939ef9d2aa71bb8fe6be6d3434dd268d76f7c0e60"

  url "https://bitbucket.org/benjamin_dobell/heimdall/downloads/heimdall-suite-#{version}-mac.dmg",
      verified: "bitbucket.org/benjamin_dobell/heimdall/downloads/"
  name "Heimdall Suite"
  desc "Flash firmware onto Samsung mobile devices"
  homepage "https://glassechidna.com.au/heimdall/"

  livecheck do
    url :homepage
    regex(%r{href=.*?/heimdall[._-]suite[._-]v?(\d+(?:\.\d+)+)[._-]mac\.dmg}i)
  end

  no_autobump! because: :requires_manual_review

  pkg "Heimdall Suite #{version}.pkg"

  uninstall kext:    "au.com.glassechidna.heimdall_usb_shield",
            pkgutil: "au.com.glassechidna.HeimdallSuite",
            delete:  "/Applications/heimdall-frontend.app"

  zap trash: [
    "~/Library/Preferences/com.yourcompany.heimdall-frontend.plist",
    "~/Library/Saved Application State/com.yourcompany.heimdall-frontend.savedState",
  ]

  caveats do
    kext
  end
end
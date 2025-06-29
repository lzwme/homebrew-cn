cask "flic" do
  version "2.1.0"
  sha256 "8fceaa6d5eedf4a3013519c9e372e3c640419abc28a2dafc00f0219094933309"

  url "https://misc-scl-cdn.s3.amazonaws.com/Flic.#{version}.zip",
      verified: "misc-scl-cdn.s3.amazonaws.com/"
  name "Flic"
  desc "Driver for the Flic bluetooth button"
  homepage "https://flic.io/applications/mac-app"

  livecheck do
    url :homepage
    regex(/Flic\.(\d+(?:\.\d+)+)\.zip/i)
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "Flic.app"

  zap trash: [
    "~/Library/Application Scripts/com.shortcutlabs.FlicMac",
    "~/Library/Containers/com.shortcutlabs.FlicMac",
  ]
end
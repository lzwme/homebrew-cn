cask "hackolade" do
  arch arm: "ARM64"

  version "7.4.6"
  sha256 :no_check

  url "https://s3-eu-west-1.amazonaws.com/hackolade/current/Hackolade-mac#{arch}-setup-signed.pkg",
      verified: "s3-eu-west-1.amazonaws.com/hackolade/"
  name "Hackolade"
  desc "Polyglot data modelling software"
  homepage "https://hackolade.com/"

  livecheck do
    url "https://hackolade.com/download.html"
    regex(/Current\sversion:\sv?(\d+(?:\.\d+)+)/i)
  end

  pkg "Hackolade-mac#{arch}-setup-signed.pkg"

  uninstall pkgutil: "com.hackolade.pkg.Hackolade"

  zap trash: [
    "~/Library/Application Support/Hackolade",
    "~/Library/Preferences/com.electron.hackolade.plist",
    "~/Library/Saved Application State/com.electron.hackolade.savedState",
  ]
end
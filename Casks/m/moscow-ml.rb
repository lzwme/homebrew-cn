cask "moscow-ml" do
  version "2.10.1"
  sha256 "4b3e2035b106c688e43e7d415ca74ca8970f74656cc2c17326c5fb7d1f948ca0"

  url "https:github.comkflmosmlreleasesdownloadver-#{version}mosml-#{version}.pkg",
      verified: "github.comkflmosml"
  name "Moscow ML"
  desc "Light-weight implementation of Standard ML"
  homepage "https:mosml.org"

  no_autobump! because: :requires_manual_review

  pkg "mosml-#{version}.pkg"

  uninstall pkgutil: "org.mosml"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end
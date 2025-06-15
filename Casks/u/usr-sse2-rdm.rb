cask "usr-sse2-rdm" do
  version "2.5.0"
  sha256 "9d583e43742018e45bad79c8af9e0accec6b6a10d94c60ac7d31721bbb3c237e"

  url "https:github.comusr-sse2RDMreleasesdownload#{version}RDM.zip"
  name "RDM"
  desc "Set a Retina display to custom resolutions"
  homepage "https:github.comusr-sse2RDM"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "RDM.app"

  uninstall quit:    "net.alkalay.RDM",
            pkgutil: "net.alkalay.RDM"

  zap trash: [
    "~LibraryApplication Supportnet.alkalay.RDM",
    "~LibraryPreferencesnet.alkalay.RDM.plist",
  ]
end
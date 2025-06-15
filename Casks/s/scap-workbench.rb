cask "scap-workbench" do
  version "1.2.1"
  sha256 "e5a250a8baa6107ba719fec0d6236ece5658e1adb3a5b8dd207c00b51a311628"

  url "https:github.comOpenSCAPscap-workbenchreleasesdownload#{version.sub(-.+, "")}scap-workbench-#{version}.dmg",
      verified: "github.comOpenSCAPscap-workbench"
  name "SCAP Workbench"
  desc "SCAP Scanner And Tailoring Graphical User Interface"
  homepage "https:www.open-scap.orgtoolsscap-workbench"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-04", because: :unmaintained

  depends_on macos: ">= :sierra"

  app "scap-workbench.app"

  caveats do
    requires_rosetta
  end
end
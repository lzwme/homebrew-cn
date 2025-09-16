cask "scap-workbench" do
  version "1.2.1"
  sha256 "e5a250a8baa6107ba719fec0d6236ece5658e1adb3a5b8dd207c00b51a311628"

  url "https://ghfast.top/https://github.com/OpenSCAP/scap-workbench/releases/download/#{version.sub(/-.+/, "")}/scap-workbench-#{version}.dmg",
      verified: "github.com/OpenSCAP/scap-workbench/"
  name "SCAP Workbench"
  desc "SCAP Scanner And Tailoring Graphical User Interface"
  homepage "https://www.open-scap.org/tools/scap-workbench/"

  deprecate! date: "2024-10-04", because: :unmaintained

  app "scap-workbench.app"

  caveats do
    requires_rosetta
  end
end
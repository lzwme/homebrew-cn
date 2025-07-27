cask "otx" do
  version "1.7,b566"
  sha256 "116a9441cfed31c28e0f9b3aa26b82f2a7186d3c8ec4afd2173c2ad460e51ab8"

  url "https://ghfast.top/https://github.com/x43x61x69/otx/releases/download/v#{version.csv.first}/otx_#{version.csv.second}.zip"
  name "otx"
  desc "Mach-O disassembler"
  homepage "https://github.com/x43x61x69/otx"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-27", because: :unmaintained
  disable! date: "2025-07-27", because: :unmaintained

  auto_updates true

  app "otx.app"
  binary "otx"

  caveats do
    requires_rosetta
  end
end
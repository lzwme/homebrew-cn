cask "icons" do
  version "1.1"
  sha256 "aff6836c0425c845afbc4d71579ebd8adf4d161f03413939ee8579b23782159a"

  url "https://ghfast.top/https://github.com/exherb/icons/releases/download/#{version}/icons-v#{version}-macos-x64.zip"
  name "Icons"
  desc "Tool to generate icons for apps"
  homepage "https://github.com/exherb/icons"

  disable! date: "2024-12-16", because: :discontinued

  app "Icons.app"

  caveats do
    requires_rosetta
  end
end
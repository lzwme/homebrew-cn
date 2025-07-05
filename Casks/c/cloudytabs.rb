cask "cloudytabs" do
  version "2.0"
  sha256 "ce3f7c71b134798bbcf607cfacea215c20f1d527d3e3464edbd6510df26e5dac"

  url "https://ghfast.top/https://github.com/josh-/CloudyTabs/releases/download/v#{version}/CloudyTabs.zip"
  name "CloudyTabs"
  desc "Menu bar application that lists iCloud Tabs"
  homepage "https://github.com/josh-/CloudyTabs/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-06-16", because: :discontinued
  disable! date: "2025-06-16", because: :discontinued

  depends_on macos: ">= :high_sierra"

  app "CloudyTabs.app"

  caveats do
    requires_rosetta
  end
end
cask "clickhouse" do
  arch arm: "-aarch64"

  version "26.2.2.9-stable"
  sha256 arm:   "341226129a261aa5a4387eda1d71d34915ff36426715eeead2bc038af214ec9c",
         intel: "25a8b8823f13e7e542367d3574661290ebffe7e0858d3c37da1203f986ad4665"

  url "https://ghfast.top/https://github.com/ClickHouse/ClickHouse/releases/download/v#{version}/clickhouse-macos#{arch}",
      verified: "github.com/ClickHouse/ClickHouse/"
  name "Clickhouse"
  desc "Column-oriented database management system"
  homepage "https://clickhouse.com/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+[._-](lts|stable))$/i)
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  binary "clickhouse-macos#{arch}", target: "clickhouse"

  # No zap stanza required
end
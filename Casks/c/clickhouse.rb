cask "clickhouse" do
  arch arm: "-aarch64"

  version "26.4.1.1141-stable"
  sha256 arm:   "e3c822c61818753928b7720b82361d2c858deb7591d2bfd772683263543feb61",
         intel: "62ebd7c949a37baf9b278da5fb5067cfaefeb6d11f27ab54818cc5e3a456c60d"

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

  depends_on :macos

  binary "clickhouse-macos#{arch}", target: "clickhouse"

  # No zap stanza required
end
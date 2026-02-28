cask "clickhouse" do
  arch arm: "-aarch64"

  version "26.2.1.1139-stable"
  sha256 arm:   "d30c678c180c5c0435694544de6127681336cdb0369ece9ed6cd0a9e36ffc106",
         intel: "373991d50f653177d3add27f6a23b8667187f64957dfaaea3d0fc490c02a8e40"

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
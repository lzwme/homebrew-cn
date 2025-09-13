class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://ghfast.top/https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "e6179be5131b03f2e0c72a63931d3f20bfb576d77ec485ffd8b01ee64816ab6a"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3821f51319a11da4e043be3076b5e3cd376d402dcd613a912c27233a2f1577b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a7c717fb67c67bb48de1705a051a81b885e3fc92be70b69bd3f7f40267baa76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a7c717fb67c67bb48de1705a051a81b885e3fc92be70b69bd3f7f40267baa76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a7c717fb67c67bb48de1705a051a81b885e3fc92be70b69bd3f7f40267baa76"
    sha256 cellar: :any_skip_relocation, sonoma:        "2464e2cc39c3dd958b3e3cd3c8dfb248344c1c48b1a995841d1c179d709e181d"
    sha256 cellar: :any_skip_relocation, ventura:       "2464e2cc39c3dd958b3e3cd3c8dfb248344c1c48b1a995841d1c179d709e181d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26785cf9c4263d7911e2434003e2fc5f9af933e8275ec39a46e0b7a7b90443a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "326deff1e45acd55b07395f656123067afb541269cf27ad0caef7c97ef30cacc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end
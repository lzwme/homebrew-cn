class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://ghfast.top/https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.16.tar.gz"
  sha256 "77c9207ccf7793a1682129dee09e58a209adfce550232193124e1c7472591e2f"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8bf26598ac13423da3014298ae58384293ded3191e9197315c3d03cb347475a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8bf26598ac13423da3014298ae58384293ded3191e9197315c3d03cb347475a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8bf26598ac13423da3014298ae58384293ded3191e9197315c3d03cb347475a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eb733f0efcc0cbff19f333aa7184ae51e93a93e71aa1a726048cf1f559152fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "990663143d2dcdace0fdf9bc5836296f4206ede1a99b97ac03c593fbecbae2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e99977060bf01d74e769702b07900bfc5ad1fdd26e9998d826d48d5f946020df"
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
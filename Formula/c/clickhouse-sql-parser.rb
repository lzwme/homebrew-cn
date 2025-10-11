class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://ghfast.top/https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "e1372f981516058e6b626016007e199cb2b62fd27c60603aaf15d9159b2817b4"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f25987922ba67db8488b910e61d43636c5a9a2146a043b0b0e9934a3832ebca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f25987922ba67db8488b910e61d43636c5a9a2146a043b0b0e9934a3832ebca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f25987922ba67db8488b910e61d43636c5a9a2146a043b0b0e9934a3832ebca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28275bb04a298cd3f45ed6e713753140db2cd03ef3fefcdf457ef0637809cc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a8b2bddabef7f26fc4fe7208e20a86dc4b5d934d62d2f3e1f3e79b25773f357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e996dfd9813f1e4734486b1488b99b9803254fe9a1ca2f1eab9b73816e6a53af"
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
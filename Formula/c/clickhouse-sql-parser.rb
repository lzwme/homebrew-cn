class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://ghfast.top/https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c6939ccdfb7437414427dca959ffca51067d5eeca7d05501cea6ddd6d6fb6302"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b048f2c19afbb7762404c6c367525d2f4096aa93b1d6f600878100fd0ebd8ffb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b048f2c19afbb7762404c6c367525d2f4096aa93b1d6f600878100fd0ebd8ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b048f2c19afbb7762404c6c367525d2f4096aa93b1d6f600878100fd0ebd8ffb"
    sha256 cellar: :any_skip_relocation, sonoma:        "12d46ef7194d11b7c10e6561981690794568def8d1dcf1275288d79ac6ecc360"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5d57f38d5b8b27e4efe2b5b43500cdf6f25bbb54185bf1e096520f7436127c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb5132920f91bb465f534b13ac9cad14195a9292b70e814bb30206ae8c0bbd5c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end
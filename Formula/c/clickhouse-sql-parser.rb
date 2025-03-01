class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https:github.comAfterShipclickhouse-sql-parser"
  url "https:github.comAfterShipclickhouse-sql-parserarchiverefstagsv0.4.4.tar.gz"
  sha256 "97e577154a69b4675eb218e21f125f065b2382ad77a06e08bb03c7bb31a4cdc5"
  license "MIT"
  head "https:github.comAfterShipclickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d0d4a4ac4f1904d7370ece32eebc711558eca70be0a79aaf46eab4f5b38ae64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d0d4a4ac4f1904d7370ece32eebc711558eca70be0a79aaf46eab4f5b38ae64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d0d4a4ac4f1904d7370ece32eebc711558eca70be0a79aaf46eab4f5b38ae64"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ad9e98d36a58a643bba7f37d8037b7c15f367a1b1e92e56f22c74cb1de93add"
    sha256 cellar: :any_skip_relocation, ventura:       "0ad9e98d36a58a643bba7f37d8037b7c15f367a1b1e92e56f22c74cb1de93add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4dd93075390d6fbaefeba1d8033d844995d18b6faf50bcc79f1f0229cb5e3fe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end
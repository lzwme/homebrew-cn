class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https:github.comAfterShipclickhouse-sql-parser"
  url "https:github.comAfterShipclickhouse-sql-parserarchiverefstagsv0.4.0.tar.gz"
  sha256 "08c6bb24ce3b6f63f74a52a0821926b3b7fbe53b70f69008b44e973a5aa74800"
  license "MIT"
  head "https:github.comAfterShipclickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d699cd4f90e59082620169ff3522bc95d02c8700623c1d9843bd9307dbfeca24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d699cd4f90e59082620169ff3522bc95d02c8700623c1d9843bd9307dbfeca24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d699cd4f90e59082620169ff3522bc95d02c8700623c1d9843bd9307dbfeca24"
    sha256 cellar: :any_skip_relocation, sonoma:        "db4513225472cff1ccbf7b72ed557b4205fd96cbf9a6d77226bfa79963f44147"
    sha256 cellar: :any_skip_relocation, ventura:       "db4513225472cff1ccbf7b72ed557b4205fd96cbf9a6d77226bfa79963f44147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e0680e25898cff9bc8e4db3ca8297f81e9bbec7017d7f953616cfdf224f45b6"
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
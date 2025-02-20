class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https:github.comAfterShipclickhouse-sql-parser"
  url "https:github.comAfterShipclickhouse-sql-parserarchiverefstagsv0.4.3.tar.gz"
  sha256 "e7285893a09463eea8a34794b3838ca979afd47a47e3ff9a0fe661fdc9571224"
  license "MIT"
  head "https:github.comAfterShipclickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26fd113b62e0ad290b47ebf3d2eb2f2c57a45631ae248fed056d01bc6618bda6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26fd113b62e0ad290b47ebf3d2eb2f2c57a45631ae248fed056d01bc6618bda6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26fd113b62e0ad290b47ebf3d2eb2f2c57a45631ae248fed056d01bc6618bda6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f07e4cb778ccedede857deddf0c833333878f4e86b316e791be2c1d7cdad2ea8"
    sha256 cellar: :any_skip_relocation, ventura:       "f07e4cb778ccedede857deddf0c833333878f4e86b316e791be2c1d7cdad2ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a515503b972f30f487447c491701dfcaa15ae04ca55c8ab2ef35575b907121b3"
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
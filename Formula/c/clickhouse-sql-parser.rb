class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://ghfast.top/https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "b07b0d2cbbea62daefd4412778f7acd061f8298402c43036c9330b222b15d6e4"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f1c26f976b3a1aeb151025394087b0623a5334585e813297fe4897bce78ce5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f1c26f976b3a1aeb151025394087b0623a5334585e813297fe4897bce78ce5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f1c26f976b3a1aeb151025394087b0623a5334585e813297fe4897bce78ce5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "349af1263521d225df38c673230d8c92bc57834b0fa800394fad2d449f5f4bee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65f5e7c7b77854ac1b71795ec594da3da8bc6676abb92f05eb2682da2dfa9d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291aca143b72d22d597f0442feb41149872a343a7c0f82d45a0cb19debc38c39"
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
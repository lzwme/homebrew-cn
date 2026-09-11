class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.14.tar.gz"
  sha256 "3add022251d78b0007f4f03b85e47867fc20a44b732203e35e356d4d2162c5c3"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e154dd44df6dd45bb79db8d6ae345790b1d3e8015ab6c4b592ca2b8f1045a6ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ade04a4cc5353858cdc481bb567a13c87c310a51e5895c139486f294f57ccdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c403563036f87fc908af09f365a1aa6d33c177e1691e77ded701df2300b6544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b12ac239be2cc07cc8ae91e5ca9779ad2d81511f068eb61395f3bf24d11a30e"
    sha256 cellar: :any,                 x86_64_linux:  "02463d96fc0cb0550fcc5b599a42e180fd73faec26d7f39b0c163dd9dd620dcc"
  end

  # TODO: unpin go@1.26 when dumpling supports go 1.27
  # ref: https://github.com/pingcap/tidb/issues/70069
  depends_on "go@1.26" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=#{tap.user}
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./dumpling/cmd/dumpling"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dumpling --version 2>&1")

    output = shell_output("#{bin}/dumpling --host does-not-exist.invalid --port 1 --database db 2>&1", 1)
    assert_match "create dumper failed", output
  end
end
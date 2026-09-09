class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.12.tar.gz"
  sha256 "9c386497a232a8433d0cd05839638abc2494d0a448eb893a64dc1098bec9672f"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "439883f962d036d53c19a8483a36ede42fe151f569ba42fa4c4bbf2d30f3debf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dc632c9a7bb623c6cbe0516024d0418f56c066ab9cb1321ed41a96383a0b7f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cd1859fd542e798bffadba9c90ccf6cf71961190b8a07aecdcfe0281a33b0dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbb0f9d7afc8110aa41c06bd985656b1b5eee2ab2a31e7e53d86a9e7499e90fa"
    sha256 cellar: :any,                 x86_64_linux:  "255635c91cbdce110ac199000b2fdca1fb021378f97ed235323089fd74ddd926"
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
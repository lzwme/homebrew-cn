class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.13.tar.gz"
  sha256 "6ee083a779adf1bee692d2d3cc3bef53d48b639b9345ca700a9f4cfa264a5de4"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f55f44ae069a9ceee83107db1e54ebd52f50c9beb60d376dfe72afef77d76ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa3d7be65f5937239e36af48d01ee806d0f583eac0d34e9ac61ac24b987b9b0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "373fbb1f0ad2531b3a23c81f6bb7563b13676ca07f23b973d61b2173f56172b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ee5abfa789bd8f8cc1b6360f2e3528e732fe4dedd5244dd9fce4fce647c56c0"
    sha256 cellar: :any,                 x86_64_linux:  "e3ec6c8461e77f68497aadbc94a955ddf2661569129c1fefeca6cecf5a702307"
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
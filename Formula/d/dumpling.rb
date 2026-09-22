class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.17.tar.gz"
  sha256 "3a72bfab6f17eda6b98010b8d84dbb66e74f9ab2f1c5205bfc086427f895b0ed"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e63997df448b5b0a108a6c27330dd5dc686d531781a520d59205dd4c9233ba53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b419fe9d07daaf48523af65646ef2428ae3207e9ccbd6d44f4888d4bc1ee53d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0003660fefe1e457a5023698768b6e2afdba001727bf8167a1413444f7aabb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "84c0f0dfdd3dad8da287633f593478f12e3c3d2b10a822c3c5f64f0d712a27b7"
    sha256 cellar: :any,                 x86_64_linux:      "b0c2944f216391c5cf44dfccbb35063d7414efd2112c643fd80f61933b199f8b"
  end

  # TODO: unpin go@1.26 when dumpling supports go 1.27
  # ref: https://github.com/pingcap/tidb/issues/70069
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
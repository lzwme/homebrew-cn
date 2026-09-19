class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.15.tar.gz"
  sha256 "ba4b13a1c80f1a0cb6a5538b223422ca9351614b0f30cb036583cb40d70a4706"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f5561b542880b245920d5b910cf6f16b07bd29b92ccb31e3f2c01f057ce46ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aae1886d695e3fa3d92c8343ca5002d7bd024375c9c9563b0f1b29a6debd1ab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ce9ff1d8afa4a2b22ec5f52ef70fc373ace491b8f02ef4d6da3d68e8d241b06"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "38ed42128090d2fb0c2c057659d3bce28a3f6435ec2b0d8a4058efb6811c6255"
    sha256 cellar: :any,                 x86_64_linux:      "d5cf12ca62e9c5ff96bd7ddae83e072b8dabb07d54dec3d1805ebcab63d2bedf"
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
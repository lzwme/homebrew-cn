class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.21.tar.gz"
  sha256 "4af9c875702ad53ba9c3e1466c2c43e6f2dc1fd0082600ad9a961138b81f4f2a"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "422a1ea4f07d71f8bafcbca0e6b1fc5cb40015a411bd82880adfb2cee26ec394"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05d501669892a7033796b5d8498d156e4eaf9072c7a5ef2160a319625e6830b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75ff7cdb0abe357a06c1ddf5c841862bdfc1000a3e0ac155cc22acb46f9a00af"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "032b1de6487b5dbd08a044849c7ba50d79146233c0954d8b6e81bc6bc3cb684d"
    sha256 cellar: :any,                 x86_64_linux:      "6441dab0856a2d440d626f6fb868a6e155b16af2cdd0a9fbeed06c8fe0cbf9da"
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
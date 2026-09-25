class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.18.tar.gz"
  sha256 "31778db46eaff76a94edc9a881eb44c2b166b8480823d4928efdc043cf524461"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "074450d6d0c35f507011115ce78d4d7508aa5ded35c1039e26b280b7dc9376fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "287c6fc39eb27bc97532f89616ea83eaa68ca7876bc1c7eae3fed478f3b77af8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f5e7730a6850c150a7bf1c10015c7bec0291d9b8c426f9e2d9dc755050416d0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9922e1dc43c3390e8e6cd723312a9f5ca7d9bbbd7dc0c4f70b61531fd40b84ec"
    sha256 cellar: :any,                 x86_64_linux:      "890201051d029bb093d3eb70165882533cb440cde3012c2424f90b6c463dff76"
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
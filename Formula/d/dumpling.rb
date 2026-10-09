class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.19.tar.gz"
  sha256 "7965526f2836419f59fde52e30b2b1169f4eaa8fe33172ad6dd58c64a1977238"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58339e186883d240942075b157719d1cb4c8482c7fb56b607fa67fd2b91a6622"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d40a0698bcd3cfa7c35bf9353979df529cb9c4a2ed3cdc649d8eb31597b6b9a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4be6ab48fb4df2288323deb7f2e12594c4954c2d5a64b27d2f2ae4ba4b8c1d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2d4a20f630c75c3ad270c329785fce2a731923a754f482545d1e5c36b8b8fc4d"
    sha256 cellar: :any,                 x86_64_linux:      "c71b1ff684c8a8676d868a60402da647e35faca722d1f2483237ed8d0c6e2472"
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
class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.7.tar.gz"
  sha256 "b5cd65bef1e4a9ee6f66b687f94134e4dee62be0b1485d0cf60a447e2f0bdda3"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b9435a60782d70798b391b3e8892420b4144fbba000bef2ca5d181cbf29ebea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9bb14003f1251691003c0290f4be61998a850e6e026552c972bd0272d10a77c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea958975d2c7a885b34b1245b5257d64190e3c3d778bd5140bfa69c86860e5ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a1aecd3fbf21ebb67ea27f48f2f552b5ea058a0b563967893766954ca445339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c24b5de125e10b2c4e3995338c1d464e4bfc7f1a1185e36fb1452ed34b03fc8c"
    sha256 cellar: :any,                 x86_64_linux:  "c6d4a097e5f163cad02a43c3e706a3d9e739ccb2c55809bbb12518be307af395"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
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
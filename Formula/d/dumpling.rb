class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.1.tar.gz"
  sha256 "db33d76ae563f951c58e3fadd4e6273e5b3541f96694d38ac636352a526ade4c"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41c7b7660cd98170e47e76c4027d0cbc6539a2ffd1297e13252fedb38072de70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba75125579546b44af30cd18798491a8d0ae78158ed6cddfdc6fcfb18085396b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4887c1e6dd488ad04fef08c32af8eda0177c26c9f124d37b4f50b72ca56dcb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "43de2c9a73254e8fbc6e62d4e7b0b216ec7743f423989dbc78927d67819965f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e38d4fa555f486819c396dfa856905a4ce326002db0888261b8e46ec00307f5"
    sha256 cellar: :any,                 x86_64_linux:  "dd5104bda3de5dafbf1b6e5e21c00ebe46dfdf48da7f4649c08a575bbf03d48b"
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
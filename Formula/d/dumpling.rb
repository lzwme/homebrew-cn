class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.3.tar.gz"
  sha256 "28e7e5721589e6948c5adb31f429b75a17ff73e464c8b4c77af40d5705ee42dd"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4bf78f22ee5c0497685285547b1ef7cf74f0319990c7831e15aa56cba8e74d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f590659f10ec631e8cbef674386f683de5a0ac1e12e5e6561bcde3a379aed27e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2410834a29318dda98b3f224916850641e390c8f3c05d3f27b2c428770d49c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e98fcb37fc92060feaf1d6f33e50efe114325ae134ffcfe2571f5f607e75b19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3de58d4532d66c287fb7b92edd2daaa504aa2ea12e9cef007837e1851dc7b11"
    sha256 cellar: :any,                 x86_64_linux:  "28a12cc5ce32cff390e0f3abe9de29d6c074f21beedca459ca62695fb67783e4"
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
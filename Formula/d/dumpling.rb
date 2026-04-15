class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v8.5.6.tar.gz"
    sha256 "6d06151f0862cc43ae6d591d004924375477dcd89b913233d666b9853c4ac9cd"

    # Support Go 1.26: https://github.com/pingcap/tidb/pull/66254
    patch do
      url "https://github.com/pingcap/tidb/commit/f641265e809082c88161f92d5c38cb6caa700ed3.patch?full_index=1"
      sha256 "3484b5c03bc2169f5408d9f95776b3f57a4c6bb6bc7a01cfa50e2da00494821d"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47a0608569387952d7081dbc9e1be7552a16fbe3da6800b5a576117c49318896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac4ebd422dd88eaf70c134551585fcc5aa6190dd9675198175dc6dd7f716d066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1d81f8f6344627d4f8fcf37103d49dbba982ff38b5e6c436c5cfe44f1e9418f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c46ed2b051dbbd7950f93462a05bd0ac424400895a6dc952adc33f764e96dae9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10601e1d84649f569cad52c31ea3b530aa8e4db6342432c54b72b32b57988e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05944c8623d9db656061717df24f269b5fd918ca44b2a6c34c0118c5c4d746f4"
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
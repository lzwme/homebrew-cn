class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://ghfast.top/https://github.com/volcano-sh/volcano/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "aa57f6b131d359c98bb31ee8d1a8bcda0b2fc8b6b42b94bc558d8d65053dbfe1"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cb70d15ecd4198530e1c97a7b825c37da2425f9cce05f2b07b9b42501d54dd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd9f6be414d8823ab16520f62f21cf017666453972674f77a0bd999f0bdce1a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "253c7991511e3a4e65e27ac565ba897713ac42b69708997f4efb364a0e7ff2e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e0e861dd124a015bbb8af32ebae49ee296d1c49ed7605478f6da71265fd83a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02c118173fac75ffbec168e5882d63d491fe0e92921e30b12fa733c2ee0d6836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8e729baa3fea7efa5aa299dce6adb10cb8f40bf4b5430792fd79120c10a592"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X volcano.sh/volcano/pkg/version.GitSHA=#{tap.user}
      -X volcano.sh/volcano/pkg/version.Built=#{time.iso8601}
      -X volcano.sh/volcano/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"vcctl"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcctl version")

    output = shell_output("#{bin}/vcctl queue list 2>&1", 255)
    assert_match "Failed to list queue", output
  end
end
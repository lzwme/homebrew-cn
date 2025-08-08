class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "ab4ea2769f522fc7feb1a439259e7e9155dc2ceb70910fa79cd0495d1bdb76a7"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59bebc305452614f481f93391a8c4567d62c7d4c38c48612fced25bc783507a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d58c8249765051f5d12aa21643d3ec001967f94323aa3680b2fa4fe5ee071aff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57d96e3db30821b53699ed0398360d47b577d5350c409ddcfad3416195bc083a"
    sha256 cellar: :any_skip_relocation, sonoma:        "066fdb0f7aace7f106e1d2a221d08ddbeb208a9d7aef60aa7b5dfc8e8e3d2f2a"
    sha256 cellar: :any_skip_relocation, ventura:       "3e117d7529fda6dffccb14d62edb1e93524927807fd18bfbecca171f7c0ebd0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14b41b9ab2635ce7203e978a0ca8d11adf50964816f3216c083a40c390cc7f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e63480b2dbff55f2cbde762e530bea282df9b5a0dfa2e5a432574bfbd3ff0cf7"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
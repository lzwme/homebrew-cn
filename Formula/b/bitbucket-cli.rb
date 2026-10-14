class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://ghfast.top/https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "292fcafaf04107986c4cb0c66a6410bc7340b2a75db536716a0dc00ab3033c9c"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e29ca603ce70ef21d3a61ed9ffc11d9e5524120ae7381f18fd07fe000c462e17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c1d75eccecc976e6811a5ebf4b0812c813827062d4b1e4fad328862bf4ede4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fff75f8f2b557cced7b690edeb90c11af1972013259f7bef36b16613487b1983"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "24ce656fd7517e3af9b565911d86d3855ea19fd71861187d7ffbb2a0531a996a"
    sha256 cellar: :any,                 x86_64_linux:      "3994dd364b40fe0c1bb00576781f2d0872e2ca963988f81f74defb591921522f"
  end

  depends_on "go" => :build

  conflicts_with "bkt", because: "both install `bkt` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/avivsinai/bitbucket-cli/internal/build.versionFromLdflags=#{version}
      -X github.com/avivsinai/bitbucket-cli/internal/build.dateFromLdflags=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bkt"), "./cmd/bkt"
    generate_completions_from_executable(bin/"bkt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkt --version")
    assert_match "No contexts configured", shell_output("#{bin}/bkt context list")
    assert_match "no active context", shell_output("#{bin}/bkt repo list 2>&1", 1)
  end
end
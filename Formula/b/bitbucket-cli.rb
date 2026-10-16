class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://ghfast.top/https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "fe1261af5079d2b9a083798c8cb69b17505f87e92708a6a87fdd9778e7ffb0ea"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd1e0bd8e5956d1169b8f6b46c7e556e6a2dabf9ff8869bf1dfe0fd3538c4240"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d168216d2dc6472f0c5c49b31499c6ccfc0a00d77e3f2ab0eaac24066160183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b527838c9bdf97a1d13b7ffaf9d92b5d42a9173b94cee7627155d0c5a08f20d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "150c9755b7c9d8fe775774970fef86fd258af8199935b8dd788d9fe2e6d8774a"
    sha256 cellar: :any,                 x86_64_linux:      "d5538e2907817d8f6c7c8caf6e79447f41b0339d4707085e9db8940d32fcc10d"
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
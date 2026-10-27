class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.128.0.tar.gz"
  sha256 "c745e5f75766035687368a5862ea460c52bcd7ab4bb5679c12976bbc3b78738a"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b4cdb1c26a6576c6b0bde4ecbb5daddaae67008fde5c9173cb99e9cce97a815"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b4cdb1c26a6576c6b0bde4ecbb5daddaae67008fde5c9173cb99e9cce97a815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b4cdb1c26a6576c6b0bde4ecbb5daddaae67008fde5c9173cb99e9cce97a815"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a46a43ff8c7d04a9cb3423c9a7fe4f1e79c31218c0fff470db331275dd6033d"
    sha256 cellar: :any,                 x86_64_linux:      "d3799a3cdab982778ce7b66e931142c47bd32ab0472c30df7415d9a735706713"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
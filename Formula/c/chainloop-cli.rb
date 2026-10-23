class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.127.2.tar.gz"
  sha256 "70f11f7e3ee2476d29e3e85c0d3a0918013b39df65191e31de6fd268f261865f"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0ad5db413b0470c17228330bd1e6117acea8cd6744fab5efb87bde374e4b932"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0ad5db413b0470c17228330bd1e6117acea8cd6744fab5efb87bde374e4b932"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0ad5db413b0470c17228330bd1e6117acea8cd6744fab5efb87bde374e4b932"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bfd3c007c818e46083061dcc681209dcea8d9046c8b6696b532e48c293716f67"
    sha256 cellar: :any,                 x86_64_linux:      "f4b8163f2acdadb55b3e0179660f3fe2e9d264bde82aab6d5de60df8f887956e"
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
class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.127.1.tar.gz"
  sha256 "40d969dd1e477834b1b0269937327508c98cad891ae4808d82add7f0b9073000"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c00522f31f92b7fe6ac5c83624b0d215246ac5d301b72800efd3eceb0650dd4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c00522f31f92b7fe6ac5c83624b0d215246ac5d301b72800efd3eceb0650dd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c00522f31f92b7fe6ac5c83624b0d215246ac5d301b72800efd3eceb0650dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0cb4a31a7a68c5b8c044c01f5951603b58e29f6f33d5a98a0393c80a61e4b461"
    sha256 cellar: :any,                 x86_64_linux:      "cb2aff907a17a51473ed00629c3e629b9badda0638a5a7243e6ec668338c2587"
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
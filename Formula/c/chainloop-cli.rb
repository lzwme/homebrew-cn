class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.125.0.tar.gz"
  sha256 "2906c9c0016f6dfa22a6a2c2a505a5c1293a6161bc43f227d3bf382393081b7b"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bf839b63e026c9647b2cec1d89151b95186eab506346d371bf631f59c55514c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3bf839b63e026c9647b2cec1d89151b95186eab506346d371bf631f59c55514c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3bf839b63e026c9647b2cec1d89151b95186eab506346d371bf631f59c55514c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "266f1d0cee7b78bc723d078d68289f928834b785503c7d2804eb913b154f7731"
    sha256 cellar: :any,                 x86_64_linux:      "71f8fcb6ef39726363ea27637755af64306d489b2e9384a98bd6024f561acbe8"
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
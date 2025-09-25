class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.45.4.tar.gz"
  sha256 "9f4b216f6a21074ba8fe197817734d318e7319df80d97401f8ebac3dda7b411f"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa03f0fbd425de66c89e7ad5d17a2583f16a785208ba8391d037c2fe67695cab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ede46c9076eba4e4e69acecabe03d594633dbca29b08b9d5f848869a9fc26d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f12dbb000755fadf619dc35232c5ec1ca152be9a843f3c287d9f323c5db38160"
    sha256 cellar: :any_skip_relocation, sonoma:        "a86364fb38c7cc44353ad4a81a9ba8c2d1a3e7c5d5c85b41acda0230efa3c60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1edfccaa1913d66b984f655c576192851651d3577ca57bb29eb62a5826d5d5f9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.109.2.tar.gz"
  sha256 "463d4147ed9dd190b6aa590f0703a1eadd47e6cf4502b5085aca8c2b89f9c9d3"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab4662d3812792b19c34d022dacdaef39d1acb5e4cff7efbf9fde26dd906c7ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab4662d3812792b19c34d022dacdaef39d1acb5e4cff7efbf9fde26dd906c7ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab4662d3812792b19c34d022dacdaef39d1acb5e4cff7efbf9fde26dd906c7ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c99790ab5cb02bfade8ecce2c7b8c003740e36a093df9815a420b695426c189c"
    sha256 cellar: :any,                 x86_64_linux:      "07b733bdeef2445ec796af8f41cefb530d4858b9de692c502f885746d158481a"
  end

  depends_on "go" => :build

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
class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.92.0.tar.gz"
  sha256 "0097b1b6122b9568f1ca7ef86ae43aab9a159dfe70b8062ba945542256991e30"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f75ea96310a683eeff7bedef5bc9f80757f62341abaa107b6c1fad39eca197d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24b3d76c5b1bf34d00d4c762f3267e8c05ab16023764b9629a7109efa62e6c05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1186c1a8d36732208cb681a35838f9c2468da39d1c0779fd02557f55766bced"
    sha256 cellar: :any_skip_relocation, sonoma:        "008aa9af1f11aebcb28edcd2e4f0c18645afb1150195394bc062086b3af29cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b837a128708a2529a39ef74d3744f17467ba06f21c72ab7c56c72372c615b7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd381c0affbd90b4e53e05567720df8245ec2aa87fb7d1fc8ee2e9dfcc3699d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
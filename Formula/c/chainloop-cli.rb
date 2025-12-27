class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "3af241a8178c90c391e523332950645ecd3130caff63e6629187a644cb45bb8c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18e541057559b90eb1e0089271bf6a03e50c1411fa6f8ff84c4fdcc0755a0533"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6abbe800909fecf9427a52870a2b46422064418c1cae4b0ff3814319d07aa2ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16a6881195c12fc1a7863e1edbaba67348666c5ea9f0475600e5c17edfc218dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "768ed98ee76aaff4a0d103e9a533dc685ae5eda8974f0a3da7a8b3d5a815b13b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5a9a8346fc4c0c8e9d60647033857eaf969f4161f2a2704b340f65bf039e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9076ec90aade23bba516af0b99554600d28e16511ac6fc434a1562afda71c376"
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
    assert_match "run chainloop auth login", output
  end
end
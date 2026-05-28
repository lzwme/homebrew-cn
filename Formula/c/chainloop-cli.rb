class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.98.7.tar.gz"
  sha256 "8c40527462ffa191e50dbd2e6eaba4b36cca5df46ff72c675436db6982263bf5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f42b2e7516e12a313e34ce01ae2a180ca493bb1849ef5389dfad00fb37d7ae50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c13d64955555f0c4210114a35d9c0ef0292c2a827e084662cd34888043cbd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38ce1eb10726f490cdc927ebf3ed08c5d0870eb544c6712f965dad7caef09ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "1261b7f05950c5c88ee4c49af742fa02a2e0d22ee791522e906bc13f1d3fb672"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6be3f2eb7482a2bc923fb5227e452a18326d283fc5dbc7979e2c8ff5825dcc1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d21a084ec01d6be3e8d6209a2a54e10d239f7421a5848441975895a817e6373"
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
class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.96.1.tar.gz"
  sha256 "372a3346ec078ca245bda13e0d4a553143515c2a80f7071f116fae7c084d1a8a"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78ca07697ebec1f56a5416811129d6584370b579418e6654e5f67138f9b361f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ac6aea0c90b2633e40cc971b0ca623cb5b40f3b63733b1caba339734804d519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "753b5bdae321ed0252e22bdc24154473eb72e6b03a6f6258ee4a9f22b7a3ed07"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ef5f9ed3f9061923e2a9a349c8718608992ebd46265ab75cb2ad5001e7e1e73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "371e71c7c7bbfe5227534ea9a0ddeff54dd31e59c85d8ee48ec48f4859e7e801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e51bcfe1dc79538d1d24ace53605a56dd86fe97788623d9a8dc66e2ca6b99167"
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
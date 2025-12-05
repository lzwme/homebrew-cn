class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.61.1.tar.gz"
  sha256 "7ddca2a3323e56a368fa95a04392c040a74a409e08678721d78b9767b866f588"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8bbe2a7dbbfcdb83e74f1f7413ab2f0201d783f051079a1f85ccb308354bec2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c69722c1c798bb66a726cbd3eefb5c9a14a4aa20a95978083de65ed962ff8cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53ef6b145f063b8ef61fb2d4864b47d2b28fa746f397e84fe969d7dbf0289df4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a89aa9f0721d0cd77798a8e237a9c6b0f90a01eb2f6d333f996c3888c6e1553"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f9ad5a2d5270c8359d34dd9df8bee26f497d664ee2574d35d859e4671559bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91ad960676d9f99ac4f95c97458b741a2138abd2a4ef99e005918a2b0863880d"
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
    assert_match "run chainloop auth login", output
  end
end
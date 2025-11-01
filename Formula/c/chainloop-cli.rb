class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "7582e34b3d36f46c5a5c90ac20f097146b31952ee4c1798a980e8e1c005f30b0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1eb3a046783bcdde75e46f4f605ad20ad9a77540d6736b60c50ecd7b54be1f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edb60d75d68efebfce1e4b6d02bec26718e53f62d1b9be1761ef6445bf01069b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cffdcb0caf66cc7371b5f839f011695a27b00e7248339530b1c1609c71f95d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b116e5e8b8565df66313c4e36729b217dffd6957184a7aa67ca08753145714a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7679c4284c6ae3301615673a53dcbcfb893e24a913efd92449252ad2c5ce020c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae1699b0e39c13763ec288c2f3e808a5d3f3607a20d3c8ce99310fe2ca9df9c"
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
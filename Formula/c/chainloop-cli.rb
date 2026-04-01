class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.6.tar.gz"
  sha256 "9b81222b0c0b975164445d0dc70a571cb3e9e1918e4e6db6a0538fcd59434e7b"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc318a3f80fb0c1b61e1393e1c1c35401a0d59f1da1752c99110e03b3e0424ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "add95f04f939666dcc60cf7bea67f2f27b2ea6d5b62ed8e9cbdfa62759322c06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1485f1b295eb3728be1d3f8065005fecfe565cefafff680fe38fe801e66435e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cadb003639e83bcef8cdd95af9a3afdfc32554bb2ed4e36bfd8ad67457617f8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cd070a01b208377839eca1367c2a95ea06ebe98265aebcfd91548bcc573d7ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "014eed35a3e2742fe43b9bb62e1677d00a45955ba548ea2ef2c8a4250955cae9"
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
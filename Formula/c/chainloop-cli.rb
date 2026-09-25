class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.110.2.tar.gz"
  sha256 "70484e417bb61a5e78ee0a093566fd14f5350d9f48b691f24a6098c366c8be91"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "141b30a625f833fcb06e4c1ca16c67e17380708eeed4ae2415033c6c6a162723"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "141b30a625f833fcb06e4c1ca16c67e17380708eeed4ae2415033c6c6a162723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "141b30a625f833fcb06e4c1ca16c67e17380708eeed4ae2415033c6c6a162723"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "193484949dd01ad4f6cbe68ac0fb7f61dfb1063c4d141776b3a7ffaf55f9fe38"
    sha256 cellar: :any,                 x86_64_linux:      "24e52f19c3f4d0bc2ca1331319c5c079f20d88f10aab62f26cb1759ee2680998"
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
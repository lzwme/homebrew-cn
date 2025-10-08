class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://ghfast.top/https://github.com/mark3labs/mcphost/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "cdc81a7dc54516e79f41ca0b11398dbbf5f7395abc95d0558a36bcfdc24172b8"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5e3fbbd13285254e20daeec0ae588e900254a82d400ccd00f2b1aee35071990"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5e3fbbd13285254e20daeec0ae588e900254a82d400ccd00f2b1aee35071990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5e3fbbd13285254e20daeec0ae588e900254a82d400ccd00f2b1aee35071990"
    sha256 cellar: :any_skip_relocation, sonoma:        "13cb5210955c7e59c347effe80e65f74a2c6c3cd20e6486ffa83ac26c5b96452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "809ef70cf9351b28a07b99b47d7bf02a55a62baa10e81c58a638080b2e011c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efea948d61f84438b3e48a22e73299cd6d24a32711e6df97b1085eff056c1e89"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end
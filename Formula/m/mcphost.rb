class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://ghfast.top/https://github.com/mark3labs/mcphost/archive/refs/tags/v0.31.3.tar.gz"
  sha256 "eb8c68f4cb63baf191b81bf252876f5b56692f9306729d71e0d95a6d82c683c4"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e9b8c10de3651a364493398dbbccca7c835e5b42f482d20843e3f2d8fecbe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e9b8c10de3651a364493398dbbccca7c835e5b42f482d20843e3f2d8fecbe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e9b8c10de3651a364493398dbbccca7c835e5b42f482d20843e3f2d8fecbe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d21fe714a4bae90bf0ff2fdd9752aa91c8ef2f14975db36963680e7325271d9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2629fa866a59e1df977c1488dfe2ac0a6a9ca2c5cd955cd965a4a19aa73d124f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa114e0884761b2cd1ee3b34ccdc1b41f7f612e3142d7d0a7df9be8e40f78f9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end
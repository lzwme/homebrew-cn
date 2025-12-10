class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://ghfast.top/https://github.com/mark3labs/mcphost/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "3484a6d95483dcf43b9c36b2bc8b4c8025fce289b4ff85c3ea4b5026aad18b85"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a18c9366470783f75bfe3dd44b89ce484e84ad5a3ae3ad14bab7cb069e452d0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a18c9366470783f75bfe3dd44b89ce484e84ad5a3ae3ad14bab7cb069e452d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a18c9366470783f75bfe3dd44b89ce484e84ad5a3ae3ad14bab7cb069e452d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "96c85baba08df8a6d2866516c9c84fa8ec0fce1f18137a6426793dc7393bd9fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edea4949eb876b07b3f5f7ed4b07f3b6570b3e16f2fc7aa1b3cffdc59eeda766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "602e326e243499daa5976dbb627cbc34537ce2419a98032e748717349457205e"
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
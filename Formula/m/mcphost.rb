class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://ghfast.top/https://github.com/mark3labs/mcphost/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "a98b6510c6dd0750380ecd2a7ac577235d01edc79c547f633c006d95ed3de83c"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "013fabfbb5e403593f3e6ab4ab9be3aadde0f30c2274b0a42e131d881162e16d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "013fabfbb5e403593f3e6ab4ab9be3aadde0f30c2274b0a42e131d881162e16d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "013fabfbb5e403593f3e6ab4ab9be3aadde0f30c2274b0a42e131d881162e16d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a2712f5477c0a6a0bbcc72cbfeadcff686c7eead0b51f1ddbeba9bb06490c49"
    sha256 cellar: :any_skip_relocation, ventura:       "8a2712f5477c0a6a0bbcc72cbfeadcff686c7eead0b51f1ddbeba9bb06490c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600072d0ce5ff91403d9edebcb2929fa3ad2cc8462c2709d99274b165983e131"
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
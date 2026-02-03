class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://ghfast.top/https://github.com/mark3labs/mcphost/archive/refs/tags/v0.33.3.tar.gz"
  sha256 "d1f5caa1ef780137cd3b84f29e27a39465aafe087ff054d9f50bb1b56bf40861"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0b68735ae93e4ea65bc36702ef8a7893407b9475714f5e7cef0b0446d11b2b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0b68735ae93e4ea65bc36702ef8a7893407b9475714f5e7cef0b0446d11b2b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b68735ae93e4ea65bc36702ef8a7893407b9475714f5e7cef0b0446d11b2b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "777a809e336348e991c6f9f90f58d11f6f3bf03c96dc1c31de7e63b39d71279d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dbbe18162234570c268f9d06a2b19ab1b50c1c6a75ddcd4a73c066f03cbfd71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aebc839f5c9fc25b13e72126c08fb0c69117d59c28cb66a34ced44934172a61c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end
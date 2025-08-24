class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://ghfast.top/https://github.com/mark3labs/mcphost/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "30c0f00b721d4ff16bae15e4c210effa7a4caf035b43a348769d2997d0b9b143"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5225b4a99bf242ce513a4e0014f27bddfa0ec167c5436acb62788c73d1491094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5225b4a99bf242ce513a4e0014f27bddfa0ec167c5436acb62788c73d1491094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5225b4a99bf242ce513a4e0014f27bddfa0ec167c5436acb62788c73d1491094"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9df69a0f4d5d5a48c767a626845f7c989d9833f7a271fc4a6983cb58f0907a1"
    sha256 cellar: :any_skip_relocation, ventura:       "a9df69a0f4d5d5a48c767a626845f7c989d9833f7a271fc4a6983cb58f0907a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f139b7dbbcbebc307b9d60dafcb7b768e9d74dff5524072bc9f01eaadce5baa3"
  end

  depends_on "go" => :build

  # fix version patch, upstream pr ref, https://github.com/mark3labs/mcphost/pull/128
  patch do
    url "https://github.com/mark3labs/mcphost/commit/008a4991ecd20b27866f458e492715c3dace2ddf.patch?full_index=1"
    sha256 "82cd1e1cfc4eebbc0ed4114a3b93e6306be73243eb0e48aa7e4c7d648070ed8f"
  end

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
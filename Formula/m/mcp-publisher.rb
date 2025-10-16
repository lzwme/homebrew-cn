class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "6675a0cfb0a51597a347f89e6285cf39de52fd5c7b64a8d86d24fb46461cad34"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "712ba92ccc84c9503d4aca0c343cc887125abc1834e8a8c8740e25bf334b1049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "712ba92ccc84c9503d4aca0c343cc887125abc1834e8a8c8740e25bf334b1049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "712ba92ccc84c9503d4aca0c343cc887125abc1834e8a8c8740e25bf334b1049"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc140f16b62426d9a952f09bba5bcaf9735dcaa9c0374dd9d42465db4b590f50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "348b256052c88ba7f0c01a58d4e510f70cd7851492b1bc3e665a1142cca42481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4456c7512da97fcea3b9977e59be4b0ffe6b80e4f9f79dc43a13412c4b8ea274"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "io.github.YOUR_USERNAME/YOUR_REPO", (testpath/"server.json").read
  end
end
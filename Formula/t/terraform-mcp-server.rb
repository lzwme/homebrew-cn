class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://ghfast.top/https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "27eaeaf9c2ef42ee842a29556798c9ccc456982a8ab1e92e04b8d8a699893d75"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01f5ad715fb526a4e9cda9ae60d995d8e86d53eecb032ee5db79544459c56cfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01f5ad715fb526a4e9cda9ae60d995d8e86d53eecb032ee5db79544459c56cfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01f5ad715fb526a4e9cda9ae60d995d8e86d53eecb032ee5db79544459c56cfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c6d6497e6f7ee805b415366162d77a5e9792a61ef2e6256a4719d1c715256ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d98e52a7b736961c2c82320101ef70c1c8e307e44188d65a32f05613029a954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e198d5ab84e4cc9e9978dfd33c33e1c6be36732523317c874ce4f510f47a8629"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hashicorp/terraform-mcp-server/version.GitCommit=#{tap.user}
      -X github.com/hashicorp/terraform-mcp-server/version.BuildDate=#{time.iso8601}
      -X github.com/hashicorp/terraform-mcp-server/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/terraform-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraform-mcp-server --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"terraform-mcp-server", json, 0)
    assert_match "Fetches the latest version of a Terraform module from the public registry", output
  end
end
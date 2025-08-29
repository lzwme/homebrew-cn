class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://ghfast.top/https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.22.tar.gz"
  sha256 "17c945bdf7d240f6419eff7cf02ed481c722904e2eaae927900908e50dc4d4bc"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be499134a660f0e619c4b9c2a99e2ff20f86c7e4b51c3f19df6917c96460c335"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be499134a660f0e619c4b9c2a99e2ff20f86c7e4b51c3f19df6917c96460c335"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be499134a660f0e619c4b9c2a99e2ff20f86c7e4b51c3f19df6917c96460c335"
    sha256 cellar: :any_skip_relocation, sonoma:        "c970bb646fb15f72c410bab779b0607452c969c188b9b2494e18395775620653"
    sha256 cellar: :any_skip_relocation, ventura:       "c970bb646fb15f72c410bab779b0607452c969c188b9b2494e18395775620653"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https://github.com/awslabs/diagram-as-code/issues/12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/awsdac"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}", output: bin/"awsdac-mcp-server"), "./cmd/awsdac-mcp-server"

    pkgshare.install "examples/alb-ec2.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awsdac --version")

    cp pkgshare/"alb-ec2.yaml", testpath/"test.yaml"
    expected = "[Completed] AWS infrastructure diagram generated: output.png"
    assert_equal expected, shell_output("#{bin}/awsdac test.yaml").strip

    # Test awsdac-mcp-server with MCP protocol
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"awsdac-mcp-server", json, 0)
    assert_match "Generate AWS architecture diagrams", output
  end
end
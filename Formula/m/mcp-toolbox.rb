class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "4a0ff01cedc7ccc8c831907af1b269c56682be7b8477fa2e09957515f73707fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5b0771136af48c6e1daa802a7e9a8acb60a0e213d6dd0e6d4fa70c0185f5cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44b72329c32cdf6b2c277d6cfd79b9251b3c2c506ca0d1bce6f806002c3a7c5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d17934d7688cbae48cf8e118eff85935646ac0ef3e318ded5b1814cc9a81145"
    sha256 cellar: :any_skip_relocation, sonoma:        "bde2ae5b8b6065fd1a608464b4bbec5563a4ce66c5e1cf0271d1f959227c0955"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "658f05f1e1f5b23c96bda37ab5d6fc8b14bc07e5d270e37cf416c50d0957c930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5010a9c748a8e6414265528657735f7bc32459a486b7dcc7ff4131d0b0ba2595"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/googleapis/genai-toolbox/cmd.buildType=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"toolbox")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolbox --version")

    (testpath/"tools.yaml").write <<~EOS
      sources:
        my-sqlite-memory-db:
          kind: "sqlite"
          database: ":memory:"
    EOS

    port = free_port
    pid = spawn bin/"toolbox", "--tools-file", testpath/"tools.yaml", "--port", port.to_s

    begin
      sleep 5
      output = shell_output("curl -s -i http://localhost:#{port} 2>&1")
      assert_match "HTTP/1.1 200 OK", output, "Expected HTTP/1.1 200 OK response"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
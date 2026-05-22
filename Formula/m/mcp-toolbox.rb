class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "959da415495ca9b7c0fef4e7817ba91bbfbb1bc63067f50126d4b84dceb23c50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb32f7a7cd73fd0d08425c1894ef59ee38372555ef86c37cfb008e3e45a1645a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66c46a1509120783ab9c0a8a9ea6394cdba6915bdb1ce19e3dff62fdf3e58a64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f24f886657aa4910321884c50acdcc5f9e103524be88edf465e87d86705adae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f837b3315482f4b2b7e793a8166acece64340b309a80c21568d3ae51ea6af43f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b35235ad43aaaf2b3b18cd19be267397ed4e191cee5a658515fae6a408cc3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db5d0dae0edcc3653f3683b66e0032d033555616da6ec2987648e31b02e687e4"
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
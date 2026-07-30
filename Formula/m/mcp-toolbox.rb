class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "79aaf44c73d6c96bc14e8b76a576dc3b138f0a5ac14b4bfd278f6d80d13d5187"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "998031fbacb6e8a4ce6e0b8af649d6ae5a13030370e3b7b3eeaf587ecf5cd9b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68f87e6caf4f93e8280156833e2e4575f68a79c1c2c16110e562eed9203f80a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5085aa31cdfff99e5d3345b80970596ab63715e1b25fe3cb016ffefa2ebd7079"
    sha256 cellar: :any_skip_relocation, sonoma:        "16e1aeda6b1258e03f7afa6ba8159b2f92e10c2fe993e442325b438de148007f"
    sha256 cellar: :any,                 arm64_linux:   "835251f5f9578ecfdb25eed9fd5af71eb1504f10c21c398f2deb01abd5b90a58"
    sha256 cellar: :any,                 x86_64_linux:  "b98e7433c408233a9b4ef39f3097e4e0daee984f53b68d8b55d90ebbb2c3a678"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[-X github.com/googleapis/genai-toolbox/cmd.buildType=#{tap.user}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"toolbox")
    generate_completions_from_executable(bin/"toolbox", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolbox --version")

    (testpath/"tools.yaml").write <<~YAML
      sources:
        my-sqlite-memory-db:
          kind: "sqlite"
          database: ":memory:"
    YAML

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
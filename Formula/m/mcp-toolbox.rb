class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "8544b048dab7025d1c5adb1695d674c6cd59fd21b3a82ca4eda59fdfa41484ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3637e011df07cdfe864e3e7b1ec12a516b0efca821019fc5c326993d9c374470"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d97c83acec0d71c3fd6873c970f0fdd3a3d23c35c09e2926babb48414c75bef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "828b4cbfeac13d3c1f33b9e17990840b47a08c4dc63c8eba8ffc269f4b98c536"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e60167be07b5051155dca6cf7f255d881b79d6fc9b06f94e6e33af552615aa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0a32e4454438f501249da1db087e4ab20385d94fc957a9b6d629b30d367f6c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9afe9852625a3554a0dbe51c8de68560a287a9dfa598d3461153ec1cdd653c5b"
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
    pid = fork { exec bin/"toolbox", "--tools-file", testpath/"tools.yaml", "--port", port.to_s }

    sleep 5

    begin
      output = shell_output("curl -s -i http://localhost:#{port} 2>&1")
      assert_match "HTTP/1.1 200 OK", output, "Expected HTTP/1.1 200 OK response"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
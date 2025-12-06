class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "689c34d4425fa50cb42cff2c6f024b3c894f4042d70f48fe4742634c3847856c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "306c4d8d1e616ec86db199f4b9c2ad56dca6c9876c899eb064521d21b321ab70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "306c4d8d1e616ec86db199f4b9c2ad56dca6c9876c899eb064521d21b321ab70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "306c4d8d1e616ec86db199f4b9c2ad56dca6c9876c899eb064521d21b321ab70"
    sha256 cellar: :any_skip_relocation, sonoma:        "76d350dd87ebd3a9b755c5c8fc5d339100e38a4f6c044535a509f3aa6b51eda5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a1dcf3f4c6920061dbb289159ae3951c7907a4c458e97557075c289bd4adee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e07f95151ecc496efe942a6fbf29d1cc9d8299effec2f6b0cf46540304c54ab"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  def install
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
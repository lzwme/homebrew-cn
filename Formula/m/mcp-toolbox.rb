class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "14651535a698702b0dbd546198f3a1ba093f4ee8983af17cba346fe5881286a6"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5111b50f840131e00b70f03b5eaaf244e0ce50864c3a468b8a5512252f10450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5111b50f840131e00b70f03b5eaaf244e0ce50864c3a468b8a5512252f10450"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5111b50f840131e00b70f03b5eaaf244e0ce50864c3a468b8a5512252f10450"
    sha256 cellar: :any_skip_relocation, sonoma:        "4435158a5b321fb24053aad9bee633f4a59df73895ba33a5cbde7d1d47bd9f39"
    sha256 cellar: :any_skip_relocation, ventura:       "4435158a5b321fb24053aad9bee633f4a59df73895ba33a5cbde7d1d47bd9f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46cd96befcd74e10139f64ab0ae362303d7fee055c7fdef377bbf8efe71e922d"
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
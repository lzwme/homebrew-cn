class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "8a4c55ed601ab2c2beb83b2ef244f330bfbf51b5dd5b9bc0e6a6437c362eaeb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b67b75d18e255735ff51e73ea2cf4efdc97f84fe63c27aa7e9ce25705dabbe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "923b93d9ed60f9682ca58844377894e4e77d165c1bde81a53002a639c30162ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9ca05b79141d9837d50ac5214c14b70a3d1aff7c76c2c50d010beea096712ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "38305e4cf532ac4960e63e1256ddf14d9fac47d4855b8162441f992e991e61f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce5eba10c9ac16db945c074eb2ad71ca49cc5ade2810bc0f27273774c8fbdf0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b86eef69e611e9df37f82d7f03d831c8fe7c67baa9f191d1b0d323356801a22e"
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
class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c6a02e06ea1c052897a826c8da0c7fbd960760c99a565cc530dbe89900b0e527"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d03a734457c0a8ff06b9a59b56e29003b405256f20589cba559660ae92b1ad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d03a734457c0a8ff06b9a59b56e29003b405256f20589cba559660ae92b1ad5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d03a734457c0a8ff06b9a59b56e29003b405256f20589cba559660ae92b1ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "43653db3dd9db0236f7c09213ea0b9ea58d5c8e8739a56e5e68d147fdb31addf"
    sha256 cellar: :any_skip_relocation, ventura:       "43653db3dd9db0236f7c09213ea0b9ea58d5c8e8739a56e5e68d147fdb31addf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b2bc28569ebb547378c4888f4a3acdd22dcdbc6631634461979b5cc003603b0"
  end

  depends_on "go" => :build

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
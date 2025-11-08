class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "6241a63f36ec86f9ddb8666928ebd3067e3f81dbfaee9c61236439f5b24c2213"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75d9598352e9ac4747e30d838c673d4f0ce4a8c783b835b8d22899b46c4724d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75d9598352e9ac4747e30d838c673d4f0ce4a8c783b835b8d22899b46c4724d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75d9598352e9ac4747e30d838c673d4f0ce4a8c783b835b8d22899b46c4724d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5df806e06db6c26362788ea114950b1341ff0a004528cfeec1254d5e73c87d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50da0faa00fed8d8fe2db8451ef378497920c973c0ec990f55b7985fc2675e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09a1e119c5326b165d408ef10685746991061de1aa3dfed23a0664c593a060ac"
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
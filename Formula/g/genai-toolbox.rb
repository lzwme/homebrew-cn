class GenaiToolbox < Formula
  desc "MCP Toolbox for Databases, an open source MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "a18dd9e173ac008f725d7111b8d70b2053dfe99049795d73a74f38ac18227b21"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f6dc79592239860bf263acf6415305d3b1bc4084dc823a543a353888e735ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19f6dc79592239860bf263acf6415305d3b1bc4084dc823a543a353888e735ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19f6dc79592239860bf263acf6415305d3b1bc4084dc823a543a353888e735ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3c6681281d19afedc28753085b6fa2ef3bc1802300dae995a237b7f22bf4faa"
    sha256 cellar: :any_skip_relocation, ventura:       "d3c6681281d19afedc28753085b6fa2ef3bc1802300dae995a237b7f22bf4faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d83f9bbb5d627cdca667f903b5712de59e31057b0dbd978e9327d1557dccfd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"toolbox")
  end

  test do
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
class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://ghfast.top/https://github.com/sammcj/gollama/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "a2b57d378d8a2741e7b6eaa762b14e6d263a9a7c3edc171be32482a491516441"
  license "MIT"
  revision 2
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c1998d62f6f2cad57b610b02ac110318c6ada4f3f5c2d42c0a7736cdb56ef90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b5a6832834c390c8857ba81c33cdd0473d978940bae72c3f6906b346cc0ee5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "229509ef96fc8756f27dbc3eeece23f48a8e49f4ea93c1bd678f100c06599ce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "588a22bb77484fad3fc2d9b1dd59adf370a8bd1941433b5cac456621f555c843"
    sha256 cellar: :any_skip_relocation, ventura:       "d8c1e67f44579b265d8cf7b9204e2a5586640708e63e5fbaf1cf1b825437d19f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b43c8dfe5b6794d45722fada43a2e351dd3bae5374c3e629df92c809323130c2"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}/ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output("#{bin}/gollama -h http://localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
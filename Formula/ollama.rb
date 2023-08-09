class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://ghproxy.com/https://github.com/jmorganca/ollama/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "b0c0e8bc237525032db26a8837f943e4a647ebc4f6a6a1655fd0e7dbda300326"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bfd62745c8776e1cb756fcd309c36374fb2af45b6f95393e7d3f8cbe6c73e23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2877b50891e7c06f07bb30df48071b108633d04280e2d67d6c173ba794266864"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bbd8af459fe8bfb871f08ce4d79e3595ca6c81220c884cef012e097fb2d3648"
    sha256 cellar: :any_skip_relocation, ventura:        "855a78084d2e1f3cce17025b7d02ec1a431b7cd960bf467777317f737be82af9"
    sha256 cellar: :any_skip_relocation, monterey:       "6d937aebd4b6abc761a4b26bea9d5c7e931bc8b6f9a7150569e028303cf62f35"
    sha256 cellar: :any_skip_relocation, big_sur:        "98c05a9addea210ac4c13f4e08e92fe70aa71cdbdba4eece3aaad400b7073913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d92bd38859ad1d04ba22f0ea6eac01ee615c334756af1fa0101399df2e8e7ef1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost"
    ENV["OLLAMA_PORT"] = port.to_s

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
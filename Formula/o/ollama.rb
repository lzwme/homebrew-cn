class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://ghproxy.com/https://github.com/jmorganca/ollama/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "339e2e6aa345afe8e991a4b9e2303ceaa0f8cf3b28f39643748e883760b6cc98"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "213a8eb1ea0dcce9dda92d3b0e47c979f69265eca7c52c636bd96cafdd88c004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcafc6adefefa0d46732285b8e587df02bdee04e9498412d4fd24d8f7bad5bfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df2e6d4036c095e9d81657dfb1a610fe9edd98ce89e91cea8b08a8d1e451f654"
    sha256 cellar: :any_skip_relocation, ventura:        "473667c02d448045ea29bbaa8e6cad76fa95f0112ffb16174d3674138e8fa3ff"
    sha256 cellar: :any_skip_relocation, monterey:       "164d3a85b375d1d915bf5baf0513c54c693b1c57685e3119ff6f89800bf874b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1a724aedddd03fc038a8dc121edcd042c32277b370cb95e80fe438f14ae91c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87fec85645b33e929f1c6be3c0d2c37347b42856ee30094bf2aa629df36db803"
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
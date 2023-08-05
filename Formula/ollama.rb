class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://ghproxy.com/https://github.com/jmorganca/ollama/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "b0c0e8bc237525032db26a8837f943e4a647ebc4f6a6a1655fd0e7dbda300326"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be7b57563a41af4f25945789a6b13ab333d7d29ba6ab643b5e15b3f7aaec3626"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc21065f4c14b60dc92ca7061c31c83b0222e1294257fc5526d19145ac4a8f7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f214551e5551f4ded0a928dae349d644cb054e4e4b8b0cea42e662e21fd5d27a"
    sha256 cellar: :any_skip_relocation, ventura:        "5c226990ef8be58abb815e04ba369e5badae02fb949c8add8f0e9c1d05ab66fc"
    sha256 cellar: :any_skip_relocation, monterey:       "8d082ba4cf7edb0058a5a67741e167950889f4638445c6e198b6dd9ea156b14e"
    sha256 cellar: :any_skip_relocation, big_sur:        "23371ceca54e2152bbba04c7764fb48244752aa99c55341f62eeecfe7651d7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6eea76f5d767831604b4e6bfda4d053cbaec2faf3f5a338f67ce996536dcded"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
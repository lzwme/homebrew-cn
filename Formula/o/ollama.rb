class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://ghproxy.com/https://github.com/jmorganca/ollama/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "40152f8876f9048d09ada31cef68475bf1857adff15858b0cb991599fdf62eac"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18891fd18f553b1a98ea0142591e7e464f1a81165edc732e6624282e88ddd5a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1efa357d39300054cf02e3bbe0461c8057b81e596c3e3dec7cfa0e9719de9499"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1b6601f78a603eb8b198af74393787049feddd141ef6174555ca4dcb591ffb3"
    sha256 cellar: :any_skip_relocation, ventura:        "0ceaec0e781c0586aeb6c3bb77aa2036c4e0c92115c1a35a222bcd08f3cc94eb"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec193c8b03cdd8d26c1daca404a4c7d0b1728eb8a5432386fe70321a80f9679"
    sha256 cellar: :any_skip_relocation, big_sur:        "5decb92e7192285b3539a0c89e2ca93b7cfec876b09d9c07e4db24e8068793e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d91084a321551bad660dd46fc8fd90c662cfa1ea3cdfaaff791544be1ab8807e"
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
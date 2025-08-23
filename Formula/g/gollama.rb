class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://ghfast.top/https://github.com/sammcj/gollama/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "e93c8f705210c54e745cbce5c58ccaf2f6c89254332c38dcf5c42d2d8c78de55"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a258e0c18e9f94bee4ea66be7fdf6b26221c671bd8f92bf4a6d9bac6bc290cb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cdd1ca969d1309293b10d74c745d6e18323a744d0545f7f98dec515cbbd3998"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0de7ad19f84e945b1da1ab74f82d3e0e8cea1b310c5ad9e30226cad658195f0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d58aac08ef5c55980e85dc9db54e394bca656d3483fb82aa8359cd50af69e45"
    sha256 cellar: :any_skip_relocation, ventura:       "07a0a51876219e737ca221b6bf21e9c10e94929cfc1cce2631de0695392b9ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31cc4c546c5eeb2fe2eca97b5cdef72f2e824df0b5c98c901e6d7c31752395dd"
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
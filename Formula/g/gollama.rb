class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.27.24.tar.gz"
  sha256 "6b51ed771d95e327e40b47d911e0b168ae6fa0491f62360995766f77306e5d63"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60576a89e58ce97d6e51d20f30ebb26c056ebe48d5c756f36fbdb5ce5f2b30f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95eee53452058eda4e33ad952d3143424287a1d683e16d6a21e512b41249e4fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e3950e4498e0b31d5fd08e03eeb4510c9315b25a2ffd036c7cc32e5c2b903b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "941a6acab3dc640b946abb0771ad9b36ab3d2dbf089cdcddb33b01d0610f0d96"
    sha256 cellar: :any_skip_relocation, ventura:       "0429186d98b52d762b09f1e0b85c4b9283c4efe4d5d75bef2a741ed88b5dff2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ee9174d101a28284716d460b2189490f6882b57b03a60b4d0fc9b44406cb7f2"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "mod", "tidy"

    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin"gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output(bin"gollama -h http:localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
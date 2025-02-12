class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.30.4.tar.gz"
  sha256 "8ef266854c43775428716b35974c2a4559c34f27550a396c7a4fa680dd86b7ff"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9107ae1c639860c2c8570a6d63c64ce8250e73387ba4a1f8071388405f7b0d00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "298ec7f4db3b27f0886add76b5c46a94f13d57cc2020e9524409ad1a78a28ed4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a9416a9c353efa5598e6e41719a901191fa53dce0986af1f485e98ef0905d29"
    sha256 cellar: :any_skip_relocation, sonoma:        "361cbfc1740d4a71ff50cdf59a96af9518fb1026c97f22e8e63ebaab83e7b4a9"
    sha256 cellar: :any_skip_relocation, ventura:       "8757466608cc1d946c57a436846d7bf69133e37132af6e1535af4df0ba634b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b92c7726a4a7666a4e0cf29334bbe7227c8d15a7f83fe3244304593cd434dcc"
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
class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.28.0.tar.gz"
  sha256 "4bca17edb56e9dcf6d2f8d13657c096da3c117ccf6234726e915c498677050f6"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd9b5daac5024cb8a586f87dc9f112e7e8d8112df42b91e070b6bc2d8331163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f027c90a985b58c3a49202a179792366ab6fddf63504e5553a1f0df9ac992fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36d9f96124076bbbb02941109f5bce2ea9c64a1dbae72fad3d52aa337439c8e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "765611836ea993448ff21b01031f6e82d98b78719463b4531560a25d6fc05199"
    sha256 cellar: :any_skip_relocation, ventura:       "0f8e94f62428cfbb10b3f6655e91f6231f782c8459ebb1a4a87def7f9d75bf64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e717e4970927c7863061184014141d966ca14c9a94156af4bd5b96ee9ea125d2"
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
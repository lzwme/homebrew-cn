class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.29.0.tar.gz"
  sha256 "a1b87d30478b8a61f7ca0b0b1a580d5084e65c5930e47a3b79fbc949c3cace35"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "338cdb69c0dc45c2d53e33910c76c821f540b615c0fe40b4daa3f954d3e4c11b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f054622b611846d59a3fe0adbaafd155fe9b89e4d2e371fc8415fd3ab6a0bad8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adf2e62ead3440fe9d4b125f96bfed4e02bf103b609949e20f642f8fde735cd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "788c2c8aafdff0edfb101c202eb0f8377c26df911f272c14b731a1c8018b7156"
    sha256 cellar: :any_skip_relocation, ventura:       "a6dd74aa8691867b99996f8b495d08c4375ba2f2bf4c1248c1f2044329b42c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c205fc7d5bd60bad77ed817cc0d03a99febb046d0844e529b4c944ecc173d075"
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
class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.28.9.tar.gz"
  sha256 "983695704783c44cfae3bd44fb0949d9335ddfb2d752da7d2555f49730276fe2"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae2150686511ea6d4cc6391a345059e38f07e3884b0d6f69b7eabc39a774b930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22ec84fe780307c5d96ee4b8633b779b2f1beaf271b1fd97a0d87341a7eb760c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "250a830b15c7f98b4e5809933f1aa53fdce3b4096b29868af29dc7d4cc17fde1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cac45d38c8d7344534021ca7d311b7edfb4b35b78acdb9d924cc32e123ab4897"
    sha256 cellar: :any_skip_relocation, ventura:       "2c3b53b42705c9d7bba35bccf445e1c78c45e4be5600c61c61854300393aa0b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ee986745d154be8c8d8da90d6cf94c3d50b53b23b3eadc6f6b9b40b0cff4ca"
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
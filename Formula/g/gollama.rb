class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.28.6.tar.gz"
  sha256 "225ef2b11d1ad75ba7d2afff8068a332a2c159b0f9faad7e90588e35953f7683"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86abcdd0ccb66e56ac9d05776faf4d4226f613cab9dd071de7e7273b044c3bba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba39611278ad4fd5cad7b49ef8cb04bcd050cbf05e6af96e5ca48ad0511639ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f00d22ff8ab47f095835837bf296fde600605393a64d6022d475808f5ee10572"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d1c567e54df3e4b462386688023b1b0e5c433ef5da515368f51aa68fcdde7ce"
    sha256 cellar: :any_skip_relocation, ventura:       "8cf85f294cf4fdbcd2967c23d1b9eb09f11cc8e63e9e265142933b9acc16582f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8834ec1cd8b81299cc1057918c1e3708051bbc51ecd28b0e1693840aeb26c48"
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
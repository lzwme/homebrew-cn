class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://ghfast.top/https://github.com/sammcj/gollama/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "1fc563d1be7b6b8e73be0c3079a02fb85a48f5a14695347d6541967afec32458"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b968289b5ccd8574033d5a9e7f10a33037e47d94f1cd943ce1f180d1d59a9512"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5764230094d0eef2083d635182e03f9d2d074c386691fac5ee30f8c45038b79f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c1b0c072d882872d9e0a1b2e7e78ad71f5dc1da3de4c7fa38ac22f029ff589f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "225d21f860afdad36d8cfdc7c0114012e36d494fb614acc28a1983ff3616a886"
    sha256 cellar: :any_skip_relocation, sonoma:        "59897e2ed59f4704aac2c9536a9acb6601d9090b82de2ad142834c4b59be926e"
    sha256 cellar: :any_skip_relocation, ventura:       "9676e306be2d43d07522c518d3592d8e100b6dbc629f3430167bc6c1835df9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b871114fbbed6ebd63027ab3748559f942031ccb36c1186bebd698ddf8009679"
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
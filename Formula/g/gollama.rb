class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.27.11.tar.gz"
  sha256 "fbbe388498efdd70cbb9633cd3f89da0f524300469c428c21d0f93ac1998a8d5"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a1d8ec3582bdaad6465e76987282830f17240ff5c573f41ca8f8f0c9ff48dd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c6a02d93f566fe8e0fa2c8fa7c6736df4b35c728dc0a20837130f3cdf681744"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20017878adef259ad0b9dfb25df52e00f13785653ebc197106668c5b0c90b2b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1ab7617625a4c9c2be568e7663c345bbd84cd63c2d028904b2323a3faf0af60"
    sha256 cellar: :any_skip_relocation, ventura:       "6b3741348a6f3b796bcfd02decca7c47bea315b5974b1053107c283c2f0ae186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32ade212b76e254166d9cc68a123b1ba7e1059c637ee23bdd10d3ec69040166f"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
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
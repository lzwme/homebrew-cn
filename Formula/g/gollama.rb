class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.27.17.tar.gz"
  sha256 "0349b6d68ec26bad53fd8a29bcc1e0d8c8b74e9cb2021c3fb923936bd5c85cc5"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ed9d3f7e7aa128fe68a892e9255699a3cc0dd6ffcf77a07bd1f667b63f78d49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52cf77810ee4e6f36f9bfc6eaf7c9f1e9bebda364bb4ac846672504f58e78570"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e437a052926df104034df6f24e5123249bdd504ebf20d94d5faaa7935921e37"
    sha256 cellar: :any_skip_relocation, sonoma:        "1221ae7ace17372ade0abb88bbc99e7bd0c4c2d45c7dd0c391ed893ad1e8edd9"
    sha256 cellar: :any_skip_relocation, ventura:       "12e53e8acd4c691cad22c58eb9d1510c4fa2ca158cb6546ec4f0901191737153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13d3a748d22530593a9ea526852d92f47a995edcab844b08208347a895d5b3c0"
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
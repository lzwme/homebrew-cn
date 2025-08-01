class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://ghfast.top/https://github.com/sammcj/gollama/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "a2b57d378d8a2741e7b6eaa762b14e6d263a9a7c3edc171be32482a491516441"
  license "MIT"
  revision 1
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eb460deaba795e45d623055b261a2a694f08fa2c99160dd644efc61fe220c8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "415161fb44a08c0cff927894d32cb38caa4460082c2d40030957c867d1adaf55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc15f26518102060d62fd7a664ad7eb0732a656d093303ee967a7c55919eb8c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c59e5c9785e8300144afe6cd5073804723de42275ed98fb1f8fc1662ccd4454"
    sha256 cellar: :any_skip_relocation, ventura:       "6766251a1477e53c9ce4149a9c4a18df86ccd0535a3a11e57b52383dfa4dbcbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9afa51c6a80fa9e039bfe5c8cfb41a108c949cfdc401ea99196dcf3752dd58f"
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
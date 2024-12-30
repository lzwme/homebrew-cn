class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.28.4.tar.gz"
  sha256 "4f77dec51e9c3725d7286ca0b90d8cc4a7472005103a375c39befc93ed2271e8"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b05353cfdc24d450d4a57fef183cd194b9c14afc8f89c36b7b09c4157c320bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a567a847f5e96baf5ac285bdac4b45c09852883831c42e7e176575b1660c415"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cec5b6173dd235980e31fae5eb6aa69216c99d236fa7fb0ed25014290349d9ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "afcc669be747aa16ca01a694817632f1d03cd31faa512122786e4986a827c6cd"
    sha256 cellar: :any_skip_relocation, ventura:       "dd202ea3ef4a393620c11443cb0faa39f5ef5061e0b60bc363cc213929c1398b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bcac96f8e886eecf52f3d4d552694a9b47540d4605dfce3aca5e3b1e9e35419"
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
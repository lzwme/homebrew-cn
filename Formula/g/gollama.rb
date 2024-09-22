class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.27.10.tar.gz"
  sha256 "a6bd0a52c3c1a52f65444bd497b728999f765a8f694300d773f908b99179cd44"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a68aa55ad73f9c767d9226cce942a23818e32dbeb68fce4c5a1d32cabdfd3a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b09685abe9791d8629cd19975adb1120cb24c3dc14a782a9238cd1cacc04db25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17c48ceb6e1eed6786552bd8f9b47a2bf865d98fe21dfd627576166c509eedab"
    sha256 cellar: :any_skip_relocation, sonoma:        "779f4f0486e505f71fe7786bb8cf61756698353e9020f11d3072c56666640f9a"
    sha256 cellar: :any_skip_relocation, ventura:       "7ee7784a0c42b1d0eec77a054939575799599e320bb79467ae13a5a95d03f8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da6b38aee826a8d086dab5fdf90eafd9814fce7148b3f8e8c4bdd385e2b1eca2"
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
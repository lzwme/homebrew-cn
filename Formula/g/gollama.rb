class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.27.22.tar.gz"
  sha256 "4b841c253eaae5c540feb006f15b4e853556e0d6aec1a6427db59b8ab07afcb6"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d76f458c3cf1d57b9ee1b139bf754438b5a4d4145206aa53297a89344a903464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26c1662ed5421ecc7792cd6911c80a17235ccafdd4ab07cf9d636d3739b2fed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9345f47ecd90099da7fa27b3f865ae0401bb1b96606e5d3ce1932c62eb5d027e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3dbeeed90252ee4e3e5d5b31412cc0ed7c4c62f7c8567df302fbfd0e54aaf4a"
    sha256 cellar: :any_skip_relocation, ventura:       "fb467bcb4d021054fb76ebe45b9a99ec198422b9afe18b205e6f9b123b3e39fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40b40fc10a76c60ca00f697b3bf419f40f3d5efdc3b4c61b6c71edc1f0297cc1"
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
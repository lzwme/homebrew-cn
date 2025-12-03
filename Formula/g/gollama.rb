class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://ghfast.top/https://github.com/sammcj/gollama/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "cb7dec4a693006979cc01f6c6a6a15169bbb2847f4dd6ff33928a90b8b05cf87"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbf01ebd23d5a090a6bd1c48e9053ba16940c24461183aa85c1b2fd1c1a3d7e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b79ddcbb1d7ae4284bc0e867a25bcff1b0762083304eb2f1806c7aebb0745672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f0e1b1ff831fece9fe97f6623d9a7a35237ae12cf9a0e419b98d38fe9deb3a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e58bbf1bbad66c9ce8afd202eff3c0dd80e4506710bdbf72da8b0714874e454f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be32deac2223be5f916ba5095e727a1ea65da4d6f1cc08c1cdfeb301279d1ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29fe0dbe82330b82a8e0a90df9a013c1c3af0108d2a0dbe00bb56c0f15433884"
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
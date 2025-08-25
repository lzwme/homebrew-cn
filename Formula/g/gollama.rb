class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://ghfast.top/https://github.com/sammcj/gollama/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "476f057d1cb50b9771eea5079341a1623e5f22bd98c851db450abbd5579bd101"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "734d2c0c905ca5dcb1d8bd03244971c291703440b77a559b2840efb747564faa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed6a3cc7ffc6007827e97668da9ffc82b44801baedff7111726ce0ad5902fa5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "581d26f85b3866353ee043ac4b615424cfed84ac8ddcca23afb7a63e1b92993c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbaae69dc42fd3fc6f7560ab5133b2e2b11cdd14a4552fa8fbf0b65200b82973"
    sha256 cellar: :any_skip_relocation, ventura:       "1a68477a45339f3d8ee1ca5278c80c748d826632c616ff9078a0c1f6ad6dd84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c69a2b4d123e9b9bd771c9e63a06ed93f37a2216e0cf909013af3343774c55c4"
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
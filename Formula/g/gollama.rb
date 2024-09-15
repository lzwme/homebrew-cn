class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.27.7.tar.gz"
  sha256 "7c1833b19357d25fa63fb6ade919384e8b9cfd1c816d76c42d4d7dee166ebe22"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4df1c2c0fc924ace217a025cff37af21a1ea93183290745ea2f101b567d1e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d23ca0c49aa7e55ef139280cadc5addc63262c125fce5c11706dd28676e51b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9996c03220337c33a9e5f82364296105648d539db11d85130a603523dcbc77a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa10f22b42df967bc8f012a16eb11612e574aaa09a09546906ac1bc72b2c3b9a"
    sha256 cellar: :any_skip_relocation, ventura:       "3337419efdc2a38073c1091875bdb701b9541b7b31c1b70882d30200c434017e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b7b8188051c75811ab87c6ef62a55ff5b74e7aafc8551f249b70373f474e13e"
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
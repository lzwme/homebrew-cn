class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://ghfast.top/https://github.com/sammcj/gollama/archive/refs/tags/v1.37.4.tar.gz"
  sha256 "35f8fa684adf6bc973617e5323275dd8b2e0dcc433509694b9284557399b0404"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66f302d903d2b066c6f3efdab5b1945935e70efe5df591555db026b96f8f48fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eaa367b432a792e3051e7401fc2825d879209162d4e9fd67acb1027c23519ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df9f9a94ac0f42f844706c43a5bf37e0956ecb3c2173f8a1200812c6e951278"
    sha256 cellar: :any_skip_relocation, sonoma:        "b917f8ca5a1737222b681ea5eaabfc871d3e0ab6ccafe80821fab661a88c0f3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "860f591a3f5eb22ad7d5ed08bdf48b0cf3f53938c01aad07bde1ea66d46e4033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b434c4994186232fa48df1d11563edc7773405319334a847fa140da98567ab0b"
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
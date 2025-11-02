class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "3f70cf19f5404fed3460a5255bfd6268508bf1a0384f12b9f7e7de24026b4f10"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a5c2455b20ec21a654419f6867afe7c5563b53162794da15d92823718e398f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e02502ad690151bc8870cb5539363c77f4d16ad383effd2fa2fe6ca3c9cf4bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a8c8cab888164c5f71f58c503cb5129bd82b0b7a69957ee102d96d3f18be538"
    sha256 cellar: :any_skip_relocation, sonoma:        "4332c4da1522aeedb41b6b3f862d45ed34993269611f20b77548d81f2b86be5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7289997dda4f5301013b0864482ff2395ba81662bc95aa5d025373226b13da65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "635f73adda9cb069481d7ed30f96e93d1b17c67d4e90ef5ed6ed6695eecda459"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-logs"), "./app/victoria-logs"
  end

  service do
    run [
      opt_bin/"victoria-logs",
      "-httpListenAddr=127.0.0.1:9428",
      "-storageDataPath=#{var}/victorialogs-data",
    ]
    keep_alive false
    log_path var/"log/victoria-logs.log"
    error_log_path var/"log/victoria-logs.err.log"
  end

  test do
    http_port = free_port

    pid = fork do
      exec bin/"victoria-logs",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-storageDataPath=#{testpath}/victorialogs-data"
    end
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
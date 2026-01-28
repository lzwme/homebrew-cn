class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "ce0933cb8ba9eabaff2bb8a1b397171f85209a7d2d04adc3a59c63cc9d084781"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aef0d61c154d6d78f6ad0ee01b543bae959086676b70dbdc25e82301d1d9aef7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "178e02ee155ee9f2cf6766d09252e4b78b60a73f32ceb360a9556d1304f55b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b19114c12c635f5f3250c5db32a04d033198c9dfc738ae5a69083fb7573b304f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b351c5942903949cd8dc051d8813e17a6776388d0a1597624f6b39937a9b82e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bab13722d12720ff5a604597be7691deb8a4a21f967d9543298f5ecd5528965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84889d88bd01f77210fd96c4b8c2c60cfcc45f25c6f45c4f49c0473b60c5592b"
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

    pid = spawn bin/"victoria-logs",
                "-httpListenAddr=127.0.0.1:#{http_port}",
                "-storageDataPath=#{testpath}/victorialogs-data"
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
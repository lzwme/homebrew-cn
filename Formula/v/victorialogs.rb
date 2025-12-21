class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "b3ce2dd0cfb9a37a6895adb4542b277b229bf23173d25d564fc06b57c8faf693"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2ac4c8ef4fcf7a8a9e751e42fc7196b4733a1c5ec0e515e7be6ed5fd8fc3269"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227e2d85932d0bed72e9fe475b5394a5bcd324c17667af1558ad4146d0dc8b92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a6256d4726ce414129e7cc679fb8f97e5f02db15e7049f59ae01906450fe0e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "47b1df9c04d5a15c21f6cab96b33444e76f5cc0be3d076324a4150ae9246ab3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bee044a2ee9d2a9542314554ba9deeda76654f5b74d1138651b47c5a59dbc55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afdb8c88d232c034cc309ad092edd420af80b4a8fe45c3a415a5f25e2772a52f"
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
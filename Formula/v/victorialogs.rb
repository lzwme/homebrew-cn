class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "59ba7d53654808e96a833d8ab495b9f2c7bb34e7c20e89c5565d06130de1c1f9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa0012e970331706bb6d2c2a46954f013feb142bef7479f07f56d15b1f254fd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c55676ab78505d7df9471e9fef586026da9f9fc2823d727a67bd8a5dcb01e02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03499ba85127cba443e412a5ef098ed502d541548d703ea6da6f3dc62dbbb280"
    sha256 cellar: :any_skip_relocation, sonoma:        "073847292b77e2c6eb3774a5d95623ce21ebab018cd7172bde6a21bb1be55319"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09ba796eaf20192ba68617209078c560bf90ba53e9203ea6739b321238be97fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd63a99c7ef12f1a313f14f1dc128126dbdbdb35f4586171f636df13898566dd"
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
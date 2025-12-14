class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "f97824da4d042406ad73f66b7c403f11e49152eebc300196e77b9c2a662aabc3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a567c4ccdb9f123fe4422d20617885f8faac6efd868170e3e5cb3d58ae50e8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbe436f215d76ce5ad36637aeb079697f40c2f5e52fc5bf9be28e99cdfcddb34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef417cafdf9fd6db2dbd2ffced3b5581e28b248bbdce5dff5d8d38af26d55201"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a96eb3ce9a96919b960242d078deb73b3224786494a1959a695a45f1aca7411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b067bfb1ead299bb4d028959bda9c062e3f7703966bcc9c2cfb199167a52545c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cb9fa2c48b02404a579d3d85fa65220537ef35dfb2a8424ec5faaad515b4c0f"
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
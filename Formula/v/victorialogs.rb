class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.121.0.tar.gz"
  sha256 "ef31c0bdfc82393882163ea37c0426396b3499c86b23c80ac1485553ca3f0bff"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "973234d71b801633391c46103c95fd4ba77dce9bce2a65d2b6bb484d911df57c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "943f4f9cde5b8e1b04eab9753baa600c53e28c367f47cc20993f997b12b9226a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "863c010abbcb0f5957d98f5f3826bf3ea61eb7374510b7c438b67ecba4c0f714"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1e33b6fa9c09c996d415f554ffaa997d7cbc8d6a4ba454ecd5cd42b279b403d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15665f38ccdad6a5ef0ce3b5544fb6803ae207e7296d94eb83490f7a6c10fec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c04a30b7e77d9157b4875bb8dd5ab36b184dd673347172c6496f6a3baa2a897e"
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
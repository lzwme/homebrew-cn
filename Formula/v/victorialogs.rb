class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "5a30a0fe4a51e785d88f076e5841c2c35adee4ce513e4d214f038a1ce8cce5b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46e65e80315196dc4fd778829284cc9394ee61385b44dbeabd15210484ae9c3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d60150e418742bd735c5a100c20dd1bf976100c0b7d8e2742f4d617c4de3cc97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b33b63f3e434299f447f59355dec8fb4ee3f79025cd6de0946a0c7a592b1534"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa8c67bc5bcc2d5cd3f2e6336aa41e2f436f23121fc1543f0dbf7616493682d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d271270dad022b54e6db5b97af6f1753aec542a23dc407cd3bbb24518efe2106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd30fb3a0a38811bd1eff7773112c11b0e36623b3b175a44b59c921a3e9e6df"
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
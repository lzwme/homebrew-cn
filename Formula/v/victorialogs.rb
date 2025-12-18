class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.41.1.tar.gz"
  sha256 "f10eb45646502c210dfde3d363f7b38ccc5772087b954302c93a59e757ac890d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65c4e9281c342ec5af07b0b2f96ffc9a241e666351f4514db9e90d540d6bce4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfbc64a98886bab7bf5075a2bdddb1ff228ab5db231d7a1fd10a67768f5f8e66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "828b67cb57be94912299ff962fb93daede6fd85ba6e5c5a95b83d2485535c5b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fe5fa97022f297b6d7cfa2b12c4048672ee31f2c24376d17445c8d735c3c07b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "947ca12fdee59b51869a6de58d34b312abaa4a8925eff0052761a988afc21a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62a13e33f39fc7ba73176b745d95d403b672a3fcb01a4d0f1112248f0b7cb680"
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
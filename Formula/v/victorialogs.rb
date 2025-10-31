class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "75d69fd7878d073f0e1d4ebb1363ad599a891a4498070f348ff8f07fb1c40627"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a841453378c98c0fa7f193db7c71f5f5d0897ba2461c4a164b72d0f380f61eb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ecafde18ced563593ff1ff07fd8db87827bca9e48760df0d82f912b2d5a3a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6917288cb3718e00e1977116c8afb92482f8f5d847666e842fc69bad51ebeee"
    sha256 cellar: :any_skip_relocation, sonoma:        "22cfa364b64d227b5023b1ba63267e93898c4146bef22f2ca8006f4125e6a443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac6d967a50a634c773458e600f880afad90caf01e783f843aad2b18e583ed481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ee194f1468292cbb323a1a9f00e0aefcf41e3f07a1b3e9ac6f11be6b137919"
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
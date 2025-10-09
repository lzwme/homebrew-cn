class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "671d8bae0ae865e52990123000f6cce0df779c15090965e6ea165b9edc67f4e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13cd2a52663ae2bc37b7c65980458b8d306f71d25366a6b6197af50d18abb801"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e9d5f36dfe10e0f336bcd0da3f733743586cbd33380ebdf80a78dbf78b7a75e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8e1d81c5257e54f3e689b5f10e0d13f593af50374dc838019adda7bee2bff6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c2dc0d44bd88a08a58fe1dd3a6c3acf9ce86b2d6a4f0b12d68509a74b2a8286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f9fc903d636eaf8865bdfcba0a3a5a286f99d4f1cf94fb9cfb658032e65a269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e17a0d61e07eb4f1547c8bde60150f518d0c8b82762664e7460d0e0981d58780"
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
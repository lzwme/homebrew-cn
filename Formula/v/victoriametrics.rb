class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.123.0.tar.gz"
  sha256 "fac29199ea949c420800564a0aeae33bd21539916cdfdccaf6617695083c54ec"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d7b06de6485f3446e655b96c2178ef258a081d3780a5e5ffee37efaf659fc5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cd8e94c5a1a26950b66e0e87f84a206b02f075b5678739ea6c58e7be1e648f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68023e00be6882a1465cda9d0c9acb6720c341289338b51d58c7841661530131"
    sha256 cellar: :any_skip_relocation, sonoma:        "30004f4e236e0e06e872ffb4997802c09bf37be9b2a5e98eabb52519b692160a"
    sha256 cellar: :any_skip_relocation, ventura:       "d11ed6906600ca05f81a1db1ca65a06785870f7a42a4c3c0aa0ca54568007c21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd7851916d4e55c76f066a3adf8e3ad9ae57e2d6bce1cbdd156a328e4dd0385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2af52724e10dac491999a5292e3edaf822b2afb873550e2a55a559c4a9358c1a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-metrics"), "./app/victoria-metrics"

    (etc/"victoriametrics/scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:8428"]
    YAML
  end

  service do
    run [
      opt_bin/"victoria-metrics",
      "-httpListenAddr=127.0.0.1:8428",
      "-promscrape.config=#{etc}/victoriametrics/scrape.yml",
      "-storageDataPath=#{var}/victoriametrics-data",
    ]
    keep_alive false
    log_path var/"log/victoria-metrics.log"
    error_log_path var/"log/victoria-metrics.err.log"
  end

  test do
    http_port = free_port

    (testpath/"scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    YAML

    pid = fork do
      exec bin/"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}/scrape.yml",
        "-storageDataPath=#{testpath}/victoriametrics-data"
    end
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
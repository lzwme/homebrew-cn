class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.127.0.tar.gz"
  sha256 "2bc6afd350716bdb8d881cfa4026af9554702a03c9fdb35920a71e5a70bf41f0"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24300258d0252ccf10e5f29947f3916958a718208f3a3d7b892d3e414497d1f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5277def9c5560fd23ae9808e4e77e52de56c317f47ea1f56a54085819c8f4015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3892783cd42e9d3684e81d6e1f48bd3ab3cf53c9712e4b5b7afd8d20993a62ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "755e23655ec169b9c353d5b42c50150808c83321b69cc4df8025966d56070199"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2983674439e97188fa9c3ff5866123ea83a5c00daacc2b02850c29b5d2a43669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a92bfce1a1c930f45c3c3478290e123038dd2aa554ca9ffde420583467bbd5be"
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
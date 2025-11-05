class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.129.1.tar.gz"
  sha256 "ecfa1b5587f8360c6568d46847b35b96364336b0251c220469b3dbb83261c53f"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05f1c99b6a9b760707eb22338c2cea39daebb24e5ad3b9eae377546b906eed6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e52fc85fa06bb9d0b24ba29c40c062de1d4ecca61a59dfd0c6b2fd8d6938c30e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3385626b984472b2ed01b0da660cb86a0b55ef16506a2ff84dda69e46405b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d0627f2426c73fe23674217835374aa2c3fade737c1bf85a1dd73af1422a42e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1ec4c577b0afced5dac26dbf02cea6d08e62f4da052ec990d89f39a4f95065a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a9ddb7a427b3cd9cd704db766456ca280245681b055f36bf40e49ee04fc45af"
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
class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://ghfast.top/https://github.com/prometheus/prometheus/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "cc662487db2b93e3f14adbe234fa63f20544485403a361590bfaf2840677d2e8"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d1e494efcb42640f3cc96bae1fdfe75ffb178f8bf45d96768c0b60dc2cad14b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35bc1430b538e61823ae4afce1ce453b7f7acf5256443f3984e3dba93bd1d95f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a50e1e0feffab49de0a82ee4aa24d1c988bc8ca79b7ac924145aea4354adb728"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b686dfc248bc419bc4448759cd8017b025ca6d65a8d209c7d1a37504787d12a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e146943831969598591043224bf2da67dee21a8da1a9584729451b6a502bfb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b438ac89ba3eb34d75a2b3fb686d3d0423599b0185ad99059eedb574763dead3"
  end

  depends_on "gnu-tar" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin"
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "assets"
    system "make", "build"
    bin.install %w[promtool prometheus]

    (bin/"prometheus_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/prometheus $(<#{etc}/prometheus.args)
    EOS

    (buildpath/"prometheus.args").write <<~EOS
      --config.file #{etc}/prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}/prometheus
    EOS

    (buildpath/"prometheus.yml").write <<~YAML
      global:
        scrape_interval: 15s

      scrape_configs:
        - job_name: "prometheus"
          static_configs:
          - targets: ["localhost:9090"]
    YAML
    etc.install "prometheus.args", "prometheus.yml"
  end

  def caveats
    <<~EOS
      When run from `brew services`, `prometheus` is run from
      `prometheus_brew_services` and uses the flags in:
         #{etc}/prometheus.args
    EOS
  end

  service do
    run [opt_bin/"prometheus_brew_services"]
    keep_alive false
    log_path var/"log/prometheus.log"
    error_log_path var/"log/prometheus.err.log"
  end

  test do
    (testpath/"rules.example").write <<~YAML
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    YAML

    system bin/"promtool", "check", "rules", testpath/"rules.example"
  end
end
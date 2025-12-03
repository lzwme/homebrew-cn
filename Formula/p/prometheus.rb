class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://ghfast.top/https://github.com/prometheus/prometheus/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "5e6e64535b5862b1a6247bd492f424b68dcb0dcc875424b66d9112a168f9ec16"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d8ac004639aa5ad3f69d71ab741da4a8a8f551d14fcce8c9633931ad4cdb530"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccdc00abac7a24044f797ee5dcee187a62e810f8cb3bc49d4ebeb59adef1d4b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "663ee002581597d255f201c8678b24a434cf6cd62ae585521cf01ffbf4bf2d1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "271a74bf1104ffafe398a222023592896f9bff7307bfb06c1c35549f58179a20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa7a0b03cc9ce23e169d640991910912dff36dbd12395c43362e81716f843086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104092b9507bd23459a0134c351a589a4840393d5904f5cd3f328b9966105e73"
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
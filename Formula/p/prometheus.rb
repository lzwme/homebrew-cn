class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://ghfast.top/https://github.com/prometheus/prometheus/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "905261b5a238e4e214198106dd7c50ca50d7860bfdd88fe6030c7dbed7a418f6"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1896890fdafebff4ccb37d65b778b72652d4ee09ab819e10a077b9bb48a3df44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5903eca4baa9be03e514240cd56b210a60f4e2f7e9c42e90526c7d1e47984d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82be88200d061164f43ba99b17cc0aa85bbd3ef09f6c4e59d93d3e94bc9af2dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "eef0c2d8698d0cd54008f34cd16ca94022c3ec2f2589aff819b6abb3e2cd2e7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d8ee93209efcd3580a37ad5c1c6117bf9a13a69dca40906f518bf6034d951a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e612f80046e266dfe7894d71f78538e6100555791e85884e91a6e08d036ab5e6"
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
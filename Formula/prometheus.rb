class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://ghproxy.com/https://github.com/prometheus/prometheus/archive/v2.43.1.tar.gz"
  sha256 "7f1f7a6cc3f6d8f50bd86473f05df15b8ebaafc4412007cc55e1998a98086c22"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d824de9c6804e189d4b6d400cdb92c1dfe1386d1e4bf80c574c0d07c01a03f4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0e1aa37fadadbf712c9a444c8d804a59b2ab1576503d53a87637be1482d4788"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49a0fa88adeb7b37e437363e2a3e34626a99cc553b4041172dd5709e7f9ffd8f"
    sha256 cellar: :any_skip_relocation, ventura:        "abc78768ad634e5ce1410122d2561ec1e8e950f51b47d3ccc0f35710eeb539be"
    sha256 cellar: :any_skip_relocation, monterey:       "d184b28a4426512f4278aaf7a7260301f9019c2b1cb84ab09f498a85bbdfc945"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5dc50565110990c59e1fda3f3b9339f1fafc697f93c475c1658ca7f54e05138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeb77bbb45b5d273cdabbf563fe31c0c40a5d33e19809d1ab12bba4400cd9fc9"
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
    libexec.install %w[consoles console_libraries]

    (bin/"prometheus_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/prometheus $(<#{etc}/prometheus.args)
    EOS

    (buildpath/"prometheus.args").write <<~EOS
      --config.file #{etc}/prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}/prometheus
    EOS

    (buildpath/"prometheus.yml").write <<~EOS
      global:
        scrape_interval: 15s

      scrape_configs:
        - job_name: "prometheus"
          static_configs:
          - targets: ["localhost:9090"]
    EOS
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
    (testpath/"rules.example").write <<~EOS
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    EOS
    system "#{bin}/promtool", "check", "rules", testpath/"rules.example"
  end
end
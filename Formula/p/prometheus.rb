class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://ghproxy.com/https://github.com/prometheus/prometheus/archive/refs/tags/v2.48.0.tar.gz"
  sha256 "1a7981c792bdebe8a09103a3ced63375593603c2ccd39cad236037e70628b104"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdaea14f98c055c7282fbd97425a41e310f583de8de8aef27da5b89c30f07251"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0cb36ac3ae51ba035d08d45359df1436ae3f6e82e24217fbfbc02f26b49bdea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f3f66fdf49713932c2642498d16a902d81ae28d9f56f14a46f2e766d69f28a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "577edb6f7fd13c8e09dfc0586ecb3e6de51bccd63de55d3e51e3c92b1187b994"
    sha256 cellar: :any_skip_relocation, ventura:        "2176d92af781f693b32719f1c2a074dae500e6b6d534fcee4e938df13574a7de"
    sha256 cellar: :any_skip_relocation, monterey:       "0ad13873bde6b5bdf20924cadbc16087395ba22f40076a73fd00de43d2edc40d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea878896fccd9f850d100215437009b4d39db6452502cad07d592c8b3d8d929"
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
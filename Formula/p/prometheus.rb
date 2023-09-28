class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://ghproxy.com/https://github.com/prometheus/prometheus/archive/v2.47.0.tar.gz"
  sha256 "96c62bad7016fbcbbf62413b988f006adacde13f4ef419eebaa8b0f3eba69b50"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f94a8c47e21d2eb2c0b9cecf132468db54c71bdbaa08e64133664b189bb739f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83b8e4b8103f4b0e578c3c92a1b7fe3fe86a482942d9a6d2b850a85a83787113"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15b0160315b9bd0a1de054f7fe5ba8e26e08326bc216ead530707d4cbc35d46d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e9829fe2cb10570251801daee662bf18de2292f2274e60c48521653b3eb5829"
    sha256 cellar: :any_skip_relocation, sonoma:         "b596d11e47b08f9fe04bcdc0e675bf6b84d8b2ccbd7cf5abe687c5a19aea6de1"
    sha256 cellar: :any_skip_relocation, ventura:        "58610fb5440dada1c8bd3b0c056d9ac2bb9223008f70909800eeefd6a884c707"
    sha256 cellar: :any_skip_relocation, monterey:       "8d5da5f4c79d5eaf6ee75d21da79a5caa4a0f121943d9ba65e91cc4cbc95f121"
    sha256 cellar: :any_skip_relocation, big_sur:        "3625fae460bba357b012622d5b1482ba58cef5e32fadc90c013c933052e18918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f82c22e8466698dc6359321d49b970c2f9de881b7610628db64a71be6814e9c9"
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
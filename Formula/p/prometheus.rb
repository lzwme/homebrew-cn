class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://ghfast.top/https://github.com/prometheus/prometheus/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "c52c258f77f45367fc42a28735a0f505b24377616c87621f489e494210ac6965"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ce2c1d8597230fb6af5e53839f4b78275564d186d6c19a14d7f834720f06081"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aea41f65c303c03bf27abe6798bb88e9be9577f3fad49f42b42fe13a32defc4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6dc5f687b5b4122e87d15a1a877af41489a6f0c5baf7b9941cfaac34d4a5ac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a03c5b2684f8b8313a58f745e5f0fd391f2d376c3e1677b7b78d3e21afc23b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c468f9f35fc99c7e37dab4e6e1ebfd7cebb84690b8b55ffc29afbc79029e66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c06fe3410915308e86c96911e52ef314caba1f624553cadb17bf840293069977"
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
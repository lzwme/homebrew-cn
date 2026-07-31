class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://ghfast.top/https://github.com/prometheus/prometheus/archive/refs/tags/v3.13.2.tar.gz"
  sha256 "fb8eb45635c29b120cf54aa19a1b724348d49e385062ff519b8e0b4f457c26e1"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92301d5b5bb8ccd661c65d4a7f9588372aa5e0c68667670cc7e4c1c869e7fae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f79af433d7ee66a8f8aaa0c0e8b8eadb57d5e2737172c6dbbdcfade2ce5d171a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ae63acb294e4b3c5f37d3d78deaadbc4199e708d9f2729ae37f704afd68d677"
    sha256 cellar: :any_skip_relocation, sonoma:        "7283ddc7b7df8736b276a18ae0536f3e6b980063eafc3bee86881ac74a461372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad2f6e92d545d1b2aa7fdb2c108567d12ab97734f9e204ea63361cc4c593cda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37eb91b2a2b9cbb57ff5f97d1707e6dfa0cc94d626e811876984553b4304091c"
  end

  depends_on "gnu-tar" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-tar")/"gnubin"
    ENV.prepend_path "PATH", formula_opt_libexec("node")/"bin"
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "assets"
    system "make", "build"
    bin.install %w[promtool prometheus]

    (bin/"prometheus_brew_services").write <<~BASH
      #!/bin/bash
      exec #{bin}/prometheus $(<#{etc}/prometheus.args)
    BASH

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
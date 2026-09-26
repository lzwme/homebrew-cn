class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://ghfast.top/https://github.com/prometheus/prometheus/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "d6383dea2f9b26c1673a52859c453653f2c6c046f7fb6d01db59603a65a732eb"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28086726d128ad0b3d52482100b7a23c28e7c350203bd6c05509bb84ef13293d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb64ae1b4a5e90da2d243d578259ddb8e68706f957abb15982bab7b261571171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "261b129f76cba193a585d9d67e7f4aae20a56a44fd62d54f3f485b9f3e7b7baa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0fab160304f69b07add0e434b8d1d552151c3c97d7696b25af1915913197d67b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "37203530939eef519518dc8b3dfb0456d6fa0703ba705b759569a6b8be6f98b8"
  end

  depends_on "gnu-tar" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  deny_network_access!

  def fetch
    ENV.prepend_path "PATH", formula_opt_libexec("node")/"bin"

    system "go", "mod", "download"
    # the npm-download half of `make assets`
    system "make", "ui-install"
    # `make build` bootstraps promu at build time via a network download;
    # install the pinned version into GOPATH/bin here instead
    promu_version = File.read("Makefile.common")[/^PROMU_VERSION \?= (\S+)/, 1]
    system "go", "install", "github.com/prometheus/promu@v#{promu_version}"
  end

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-tar")/"gnubin"
    ENV.prepend_path "PATH", formula_opt_libexec("node")/"bin"
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "ui-build"
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
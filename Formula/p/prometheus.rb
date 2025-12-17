class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://ghfast.top/https://github.com/prometheus/prometheus/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "4745c45427a297a8736d5796297721dfa467f3c5af6422d4ac22360580e0f0fb"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4858c4654dbef27519b7813489e50b691afd92dcde6c95377120915d725b9141"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f91bfb19bef66a301ae0067f3bfd07dd752f253112b5fb5b3029a890419672cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9635229dbe4fe6e8faf2a9eed75229c0be587fb95d4c01be78aaf396d46a30a"
    sha256 cellar: :any_skip_relocation, sonoma:        "84d81b57c1b46f4c86085be7352fe074a867789c693d1a36a73efcf4bbff1b50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a8e4a023e3424629dc7ebfa47b5f3fb241a4782b51ed73116523e054a3a62a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "178131251e84b27a64345238c701d3849bddef35a2247d57cecdc6bc881809d3"
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
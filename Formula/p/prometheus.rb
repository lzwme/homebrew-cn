class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https:prometheus.io"
  url "https:github.comprometheusprometheusarchiverefstagsv3.0.1.tar.gz"
  sha256 "bd40fd54d5a8f63cbbf5355ee056d23efce29c4af3fbf3fd754238c5d2a27425"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c646fbef4b1b9e9a9b57d9f36d2ccefa2f59d3a950e51804e258b115b0084518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82abde16d9dcc60ac54dc86e9806fb60f203fd52baa63b1917aeac35e8aac04e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38ecf614a662f781d9012869d4d3305d069fdbe0a3b597920974989685c87c63"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f42983583bad016258b9c256dfb9984ec461293efcd157e0fada03f7cd82ed0"
    sha256 cellar: :any_skip_relocation, ventura:       "e1d87553f348dbcc82002265ac2a34b0515e7cdcd34bdabc87458ce327b4e81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1a3c4b2b32a6ec7a29c07f90ee8f9c70c95eed71836d0d28b9efd2c1e3ee900"
  end

  depends_on "gnu-tar" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec"gnubin"
    ENV.prepend_path "PATH", Formula["node"].opt_libexec"bin"
    mkdir_p buildpath"srcgithub.comprometheus"
    ln_sf buildpath, buildpath"srcgithub.comprometheusprometheus"

    system "make", "assets"
    system "make", "build"
    bin.install %w[promtool prometheus]

    (bin"prometheus_brew_services").write <<~EOS
      #!binbash
      exec #{bin}prometheus $(<#{etc}prometheus.args)
    EOS

    (buildpath"prometheus.args").write <<~EOS
      --config.file #{etc}prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}prometheus
    EOS

    (buildpath"prometheus.yml").write <<~YAML
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
         #{etc}prometheus.args
    EOS
  end

  service do
    run [opt_bin"prometheus_brew_services"]
    keep_alive false
    log_path var"logprometheus.log"
    error_log_path var"logprometheus.err.log"
  end

  test do
    (testpath"rules.example").write <<~YAML
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    YAML

    system bin"promtool", "check", "rules", testpath"rules.example"
  end
end
class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https:prometheus.io"
  url "https:github.comprometheusprometheusarchiverefstagsv2.53.0.tar.gz"
  sha256 "8a3fd7c4614f3fa94fe04e8c8673dcc6d482c7e3a86101fa94ac807993d6aa00"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e211330e491646bedf90ebceac94f49a20871d957dfe34f0f29678ecb71eaca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6538b7c47675bbe1553a81f9993e0d45ca204e18433a4185e460ce558a75c1da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b555eb3e873a7b097a2e59329d99ff3d24309de181115f19bf0ca934f34d404c"
    sha256 cellar: :any_skip_relocation, sonoma:         "93ce7f17061dda626aad6ffa76f04dc6e9fc3b5b8381863b1e54a30bcce8408e"
    sha256 cellar: :any_skip_relocation, ventura:        "504a99b11b69a0063f8ed1d8e98abfdc4ed4a4685dae62af42f1c73686b7fb36"
    sha256 cellar: :any_skip_relocation, monterey:       "06c226e795287964de0185849f5ee8cb3278bc6c85c9fece2cd7dc41164f2e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d9168bedc7414086f786302ab2d4ada7d9fe6cf7fba92b85e783bb566ddc011"
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
    libexec.install %w[consoles console_libraries]

    (bin"prometheus_brew_services").write <<~EOS
      #!binbash
      exec #{bin}prometheus $(<#{etc}prometheus.args)
    EOS

    (buildpath"prometheus.args").write <<~EOS
      --config.file #{etc}prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}prometheus
    EOS

    (buildpath"prometheus.yml").write <<~EOS
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
    (testpath"rules.example").write <<~EOS
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    EOS
    system "#{bin}promtool", "check", "rules", testpath"rules.example"
  end
end
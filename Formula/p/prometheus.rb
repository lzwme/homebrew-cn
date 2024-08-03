class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https:prometheus.io"
  url "https:github.comprometheusprometheusarchiverefstagsv2.53.1.tar.gz"
  sha256 "6a36ad9fd6ce2813c78aab1da98d7725143bcb73e4fe1e2597c873537f7072af"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec90a82b3c14aa4f4bb7192291f3856e033a0875f7be2586899526894a879f3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74f5bdfb454a853f459da2feade2248e35ec0e2b858f54f4867360ca42b2cef0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c5ab9359083c25220ebaf57a4d9ba668ad7df1dec709c1b01c9cfb672843458"
    sha256 cellar: :any_skip_relocation, sonoma:         "85b35af4d6a1711003a5de84e01526bad1f8bab0c030ddb0b4cf71893c1157c9"
    sha256 cellar: :any_skip_relocation, ventura:        "fa443c6c5df8580ebabb161feae00084d25877a4adac0681f1ecfd2f2fa5198c"
    sha256 cellar: :any_skip_relocation, monterey:       "057834c7baeaa9ff95cb45562e4e418eb66c44d7ca72050d5db2f120c4856fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c909c294dbaadf7085d8080b1a115b3cdd41328f257d207db97e63ca8ba1da"
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

    system bin"promtool", "check", "rules", testpath"rules.example"
  end
end
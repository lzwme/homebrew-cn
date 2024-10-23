class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https:prometheus.io"
  url "https:github.comprometheusprometheusarchiverefstagsv2.55.0.tar.gz"
  sha256 "ab1b5902627f20643e158f7f51764baf2ae550ae9e2106dff1cd17ebc59ebc91"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d646f3e72e8537863d848b68d6ea5abd524ca4f7ffdfa3e983e51b76f34e4f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1adab1b4c04502c67e1c6765478430018586a66268a74b7e96bd42130c96ab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae95044332a2046c7ebd8cb711cc0d6197c519e036a21c0ef6692b4abbc0b139"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a9ded6be42a91ac3aaa7bbcb03b03600ebae05da85355248cc06ee6451098b9"
    sha256 cellar: :any_skip_relocation, ventura:       "8c71a11b01d15eb2cf81b6ecd6d8cd6968c10d2dc34abff7ccb13d728b27a17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7fe2f9bd8bfcc0a5f38986685c30ac580e0988a1613f45d5c1ad6e045f7149c"
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
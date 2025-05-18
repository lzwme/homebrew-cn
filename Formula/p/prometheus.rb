class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https:prometheus.io"
  url "https:github.comprometheusprometheusarchiverefstagsv3.4.0.tar.gz"
  sha256 "8990ccef432b81b2106e39b8ff3ab8012b1d92c189c4e6c13303dff50797bf4a"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e63207f099f62c13a7077ec3d2452f3ac7360f8ea31657269f0384638c15455d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c4636e0795bb394adb1e7bccdc2ceaed3dfe9185dc09c0725ec3176935c7793"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b152504d498d8d62304c3d7334ccff491ad29c8d268a6ec6aeb14bf6787dcf92"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbca734352e336e6752603019f080741baee2e1244b63f67a0fea5f058ed282f"
    sha256 cellar: :any_skip_relocation, ventura:       "2d8e9dbce4b3f372e38f04ef6a013f89161b517c306a20f4d6a2465106e6c8c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9bdeca5c37a2116cb46462dfa7214abdd1e218d0da42f4890a715068aa82403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9747cd0291ab44f1c49ef0282055ce1528e65eda85082a4888b93738f92a36f"
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
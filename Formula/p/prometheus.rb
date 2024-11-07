class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https:prometheus.io"
  url "https:github.comprometheusprometheusarchiverefstagsv2.55.1.tar.gz"
  sha256 "f48251f5c89eea6d3b43814499d558bacc4829265419ee69be49c5af98f79573"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61aeb6409b3b328b13ce2c6e4e8951846937269126e38d82c9d899baa2a58904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7420458c0b84ec1bb64bdbde3a5b17433461d208d31763b2c1556d5e2aa4d06d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "381549dc1f0bafa489bd2d46191b865d152a7b11803079f4562fa3d1485aff23"
    sha256 cellar: :any_skip_relocation, sonoma:        "c34737565940e3a4e30bb995e8d7917effb4f96f20a45a8037786ecb214fd3e8"
    sha256 cellar: :any_skip_relocation, ventura:       "108bd9d655eee8e3c1fc803d95ad01e3a0cde3c786a80659c90cf82efc0f4f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e0390f81a938d8e1deef5f32128b800238658f344e23175a88746f166ddf6c"
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
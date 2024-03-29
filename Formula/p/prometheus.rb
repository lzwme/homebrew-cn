class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https:prometheus.io"
  url "https:github.comprometheusprometheusarchiverefstagsv2.51.1.tar.gz"
  sha256 "6c6230db958bd22775bbfaa6a3db1e1cefa411ded6495fe93873b754945cc748"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e082fe2d9b385736970da0f7cf7f0891d89c089b79399f73b1075d39d2aaae2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a7202d15158d82b21b2f195f31b1de7ddf52b8377c62df526411573dec87324"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8e98d8dc5a72c7a3bf0b49cd76374b22963a1a93eb828a12becd9803e387af4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7676fbcfc63edec30423bda12dc875d06bc37c52669ec20af4cf963b7315bbae"
    sha256 cellar: :any_skip_relocation, ventura:        "fe0ae80534864884fdc6c927fac9f71831c40fc7e4e91ad2e4149d0124e47224"
    sha256 cellar: :any_skip_relocation, monterey:       "fd629df2c92d00b4f05aae56672d6ecf7903a09c4261e93e34a2093db96e278c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4058f9703764cddc2cab7c842d934b2a3e73b38fde05224142e131a2fd61f726"
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
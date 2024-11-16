class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https:prometheus.io"
  url "https:github.comprometheusprometheusarchiverefstagsv3.0.0.tar.gz"
  sha256 "7279a012eb12fc91a6887dd6cf09c3e4b68985b8726a78567493bb84902e8bc8"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8c921e53a41be58369824649a739fca3b9e1f6a72bf20c03e5009c7e1522954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c20bc8e7d44be6dd7c67d77f80cb447d5d055025d29919a61bb3ac68d644c258"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5db70367602e1a16ac9aa440b17e9fb315e2e419e4e9fcc9bbc41645ee00e37f"
    sha256 cellar: :any_skip_relocation, sonoma:        "55d83a8b363aafe74ac6a9596420653a24e31a9961a8f695291645db767f8cc8"
    sha256 cellar: :any_skip_relocation, ventura:       "25311bc2b774cd69a120536dee71ca41d2643971a435c6f6f8f7a8d3e0efdf99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc63f4348bd32bbbf18938dbc8c44ccd1cb579cfb352f6e3557299ebca3e0e6c"
  end

  depends_on "gnu-tar" => :build
  depends_on "go" => :build
  depends_on "node@22" => :build # pin to use node22, due to node23 issue, see https:github.comnodejsnodeissues55826
  depends_on "yarn" => :build

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec"gnubin"
    ENV.prepend_path "PATH", Formula["node@22"].opt_libexec"bin"
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
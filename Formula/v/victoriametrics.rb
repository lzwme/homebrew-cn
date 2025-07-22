class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.122.0.tar.gz"
  sha256 "2893e0151f744e28743ba0a1b3155254a88739fd53e38dfc074521522e10328c"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb506032b3ebcd83fbef20963a0fbbe04d345e994833dff9243626d89fefe088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3c9aeed728da69c7d011ed06b871bd64cfaf66a4383242f39639bcabb7138ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d36a713f15d518fe0158fb7dcc1739c153531a8f82a611513be58ae870a6270"
    sha256 cellar: :any_skip_relocation, sonoma:        "e62fc80e91cb83b1b15d14df40e8387598efd9930935eaac7b8eabbdc800af41"
    sha256 cellar: :any_skip_relocation, ventura:       "87312e384031b23ade1f63a90dde4476a28d6821dd8af02442f203839345ed34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e4c133068f728c3719018c40953585bde635d3af0a3e22b7c010568b54126f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9491f4b2ce755f6a1538a1d594575683c2536d864baf5e385b379b4e07f383"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-metrics"), "./app/victoria-metrics"

    (etc/"victoriametrics/scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:8428"]
    YAML
  end

  service do
    run [
      opt_bin/"victoria-metrics",
      "-httpListenAddr=127.0.0.1:8428",
      "-promscrape.config=#{etc}/victoriametrics/scrape.yml",
      "-storageDataPath=#{var}/victoriametrics-data",
    ]
    keep_alive false
    log_path var/"log/victoria-metrics.log"
    error_log_path var/"log/victoria-metrics.err.log"
  end

  test do
    http_port = free_port

    (testpath/"scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    YAML

    pid = fork do
      exec bin/"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}/scrape.yml",
        "-storageDataPath=#{testpath}/victoriametrics-data"
    end
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
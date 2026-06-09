class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.145.0.tar.gz"
  sha256 "4767d6a05468d370b7777cbdb0fc657e20052f9e3b70d99613784fea0f02ff54"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fc557c0416f747b866c532752ca836c95fd120085e6b4eccfff5dca8fbb70c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7871d35a239cf7e236af10724eb4ec9bbe471d6935a1a6628231ea3d8c9517b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daa9296d32d24ebe86d60d5ea7d77a767bcdc2e0241246e99a4e0d450c4ffd83"
    sha256 cellar: :any_skip_relocation, sonoma:        "92507a7a1335e81c162309f6f698ed00a6ebba1d4bd14ee5ca85fa9f29425bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d2fee0231434e2aeded1fb4c03e4a657f7dce9b45b3db50a06c5f45924504d2"
    sha256 cellar: :any,                 x86_64_linux:  "10ad0e845a1ac4fc3cb72d26fc680c23c59afabaaf86dfb7a1b811813218b921"
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

    pid = spawn bin/"victoria-metrics",
                "-httpListenAddr=127.0.0.1:#{http_port}",
                "-promscrape.config=#{testpath}/scrape.yml",
                "-storageDataPath=#{testpath}/victoriametrics-data"
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
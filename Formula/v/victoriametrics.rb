class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.106.1.tar.gz"
  sha256 "e856eda2e9b9351d4a24ccc904a5ad9d70dfb48edf6573d18d49df8976cc37d5"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e702c5b99ae2c30bd4b919522b18235cb652d90d216d487170f4626ae08680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7752dfe947beeb2cc2bf244281a3345e4b56d382acc57bf3912365a5fcb46fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fcc0eb28e20394f38acf883594c87746cb1ecfe811989883c99400db41064b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a00afa0d2517176d600ce8cb7da1b49b054134a0ceff312e77f623c22feaf65"
    sha256 cellar: :any_skip_relocation, ventura:       "d66d68da11d43819884b2d62bc6f9e656d8a13d942e0a487965d98b7e892092e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fc3ff143a3d60ff2872872c541d22d13c3a5ef34977bee5d9bca3b0e1b0c131"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comVictoriaMetricsVictoriaMetricslibbuildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"victoria-metrics"), ".appvictoria-metrics"

    (etc"victoriametricsscrape.yml").write <<~YAML
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
      opt_bin"victoria-metrics",
      "-httpListenAddr=127.0.0.1:8428",
      "-promscrape.config=#{etc}victoriametricsscrape.yml",
      "-storageDataPath=#{var}victoriametrics-data",
    ]
    keep_alive false
    log_path var"logvictoria-metrics.log"
    error_log_path var"logvictoria-metrics.err.log"
  end

  test do
    http_port = free_port

    (testpath"scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    YAML

    pid = fork do
      exec bin"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}scrape.yml",
        "-storageDataPath=#{testpath}victoriametrics-data"
    end
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}victoria-metrics --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
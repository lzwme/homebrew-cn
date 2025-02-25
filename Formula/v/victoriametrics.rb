class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.112.0.tar.gz"
  sha256 "a9f74f01059477355048d7084ba446ae6400096fc055026af9ba84576d12b706"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "582eda772f25c99331f25123443212b11e4dc2c9313ea6066d6910158b5182f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cd96813d49033799390b95d61b2e2712b989541ca095f6f639dbfff376458a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1cfa74a31dede1609f416b74ff7c70514b0fb5f3d5aa17a12c0c84c4388f676"
    sha256 cellar: :any_skip_relocation, sonoma:        "915634a86bf532c89b0294da9098dc68b464898c8ab7ae3caf51248f7441d643"
    sha256 cellar: :any_skip_relocation, ventura:       "a20df37c52076a9d06296ce7c7dfb6becc62cfff41cdb05f9dbd7a17e861d76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b5e611dc7c2474f194519e0bf23ac971cd8942d5069aebf7c67f002c9988a59"
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
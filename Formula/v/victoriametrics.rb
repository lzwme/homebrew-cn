class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.111.0.tar.gz"
  sha256 "421cca69dafdf32d3b0d519a9f84695384ad04bd656d0b179a37dd08bf08f827"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43b84e9120409a3de77b26ffbc1c66e72897330a7a8eadab12b0d4601a0d1c85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "389e540c45ce77e2a940b4b4c268534cd22fca2a3aa69906966ee5607d86f463"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67e6fbb665b7927a17e3c9397b775747bc512f468060ee1e80a59e3d6a418a30"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3c2090c97fcde6334747d8763fdbe4e424721700cffd0e771f2fe3ead5cc443"
    sha256 cellar: :any_skip_relocation, ventura:       "36ecb118c3cb2f3c55a7fd8a164ee9654f8229d33d581a88463da964b2219243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac31abbd21774fba12cc653e0330ebf357d273df057451c8554abda5b9ba3b4b"
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
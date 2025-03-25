class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.114.0.tar.gz"
  sha256 "e4b1ec261e4059b310248033ff2c682ac5eb09572ae650f65a5dcf3f6492fdd0"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39b6d94f335140d6689e4d5aa4bf37db31ab4d2a92ebda6a7c1db8f7e208c545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8555da62afee9105cae2c739e223dd716acb8d393d9b79360cf7f3fd1fec112"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfb273eaf33be7b08526541b650e8fbd51a68234633de1f28964929edfb80086"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dd3149b964789f2ef6d0f936fa31d09b9fa241a06270c27f4238c6164015a64"
    sha256 cellar: :any_skip_relocation, ventura:       "672c6c495a78fc22440ee9a2998c039b20534e2ce3e74f1c4018bdd237e08642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b077f9eff329535fa0b9e9b68d159c4595d8612f404c911e07a5dda624d2580d"
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
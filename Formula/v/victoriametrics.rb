class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.117.0.tar.gz"
  sha256 "649fe3e1755c7c2b9ded8ac1bfe59d5b01dd6c7950a83d9ea42d89a22f7a31ee"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "253f54a0b3a7983fa50014877521a2f641eaab88f544d429820475b2bf0e17bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c51dbcc7969bb4ba80c67faa61927cce4d0d7422e5f16c9fd97548ff34abb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14b7d847423cab7fcd87dbc4b96e30b5b0f1e4b54fe4f7e200c31085fc6b548d"
    sha256 cellar: :any_skip_relocation, sonoma:        "11ebaec143cc688b17beeb9133e11ded07b5c28474bd18fb7981afa4347e2cd6"
    sha256 cellar: :any_skip_relocation, ventura:       "bc1ba4f25d01c7d6c8b3b38e6d98e7972a07eb502b0f8e30630d24ffe760c019"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b76b29525a4dee4fbd78e1c1b49e1dd6b2888dba8c0c4cb436a8ed18661f342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17d219451b1f5969c6c68bb82847e7449400d8a87489f25e5805ab10f7fc7b6d"
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
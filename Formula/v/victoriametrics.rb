class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.109.0.tar.gz"
  sha256 "5ffefd8d60908b70f26c9d1cf619741be637827fc012c813356e59b74144b1f5"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de90030e67a01bd2f7415b4261463bd8cb102ae666d875429c02f89f82be048e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eeade7f095e474bc0dd20808c45fb2d6a38067551666bd14127bec9a378defc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c87c31ef993872e8bc7ae6e95f727811adc8fa3388077c4dbcab1d0c085acedb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7702d547dc4ada8357eec8be02554c4b053f2fe2b4e8e7f3fb9a822f44a6486e"
    sha256 cellar: :any_skip_relocation, ventura:       "b181c5fb68ae1348fe1b9c8a1b45e8d609e3b96bc4094c1373975d5b4657eced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3742750470ac58006af7c573a46379d910090abaebf36155d2422fb2985ba81"
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
class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.117.1.tar.gz"
  sha256 "879584545c160c3196410ef9f2f0b25a0512b65b2c4fa2940a428ec6c1e21dcf"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a09b1a01afc262b6d1fcec7ad6ca6a6c38a61b07e2472489ae17c31c2d19b6cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97cf4f8288f1787e934464a6900f9a1342c268ef8612bc0703b43c9821dd866d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b95be290b3321027b0fdabda27803f7b22bf8d093252d4e3214126c71e0726c"
    sha256 cellar: :any_skip_relocation, sonoma:        "38f5ff11b3c3472bae798883b628ef5caa07297ed348705e105e13ea8ffc721d"
    sha256 cellar: :any_skip_relocation, ventura:       "631316ede9295286bde3cd3bb4235add6b5f83e22617c3bc189b0977a3c94cd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "446a537497d162a0d6eb44d4ae157849b81891ffe06ecba5ab02c6cb051b5670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8696a98a0612330ed2bb851174b28b5b1d257f82b83c36e17762d891651c686d"
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
class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.119.0.tar.gz"
  sha256 "df88d2dbece7de3dc95ae20fdd4b172b96776c608eed6d83c3e0fc5dbf3c46ec"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2286d872aec08ea21968fac5fb12e30fdcaeecdb249c6dbc81c65da8273e5536"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5f8770d881dde57e76cbf5aaff9ac7c1fed74de8da4a7fcc032623a429a0aba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b2024c784c17ced6a983067c673be75e902d66cb6fb0751706bebf8b6ef95dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7032a6453c56cb72ad45176b89f380260de4798ee63d551c57bc71ce3f13a3e"
    sha256 cellar: :any_skip_relocation, ventura:       "8b82f40f65cdcbfcddd9b465f4a885b2ca111d79d6e0a2b6c22a2b325d5b057d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d73add2afb7b8bc15751e421e1d73d14e36d4499ff80c755a6d22eee57f294de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d215b7bf9415178f3a04bbef7f079358376c85d24b8d9e8af61a362d16372e8c"
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
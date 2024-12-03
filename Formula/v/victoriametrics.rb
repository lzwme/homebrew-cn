class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.107.0.tar.gz"
  sha256 "e42278a77d4e20a86e38cc9581541f64c7a84318c7ac47a95257c148ac2e3221"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ace59dc00b135277b74b03be186166696c5ef488070dd04334cfc970ab6e0e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a89cbf7cd99f2faaa3cf7ce45dd1eea8ee7b1e2754e1679d16de2ae7e547588"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c76f0ae6ed112324cb9d53a6546b9d62469c5a628924b30162472e045bd8ba1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e37ce240ca3c273a222eb6712589be30ae215ec1aa4d741f0b74f19ea43c2ccd"
    sha256 cellar: :any_skip_relocation, ventura:       "f6c3c85aa1c3e16494ef0ac195077175037a553e6e1d299a74bf9e6eaf905deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb95be3a6c5ddbfe17e5a3fc6aa59950a8050c1c27919197e23c380f2fb1e46"
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
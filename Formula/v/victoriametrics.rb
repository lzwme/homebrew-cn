class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.108.1.tar.gz"
  sha256 "c8fa5d8d5f1375687ba6af68734feb1938050b8758d02284a2644e320c0d5b3f"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d33782f7a2f0e101c8d414c0aa1036874b09c1ecc0d91dc536013ac1c0a1f6b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be28ddb2eb8357fdc38de47574e5a612146f2dba81a6c87b90920a6e057d5d25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84c0f63188772b96fd42a65d0e464a66f1291032b8d58114e4b9f54c9a57f889"
    sha256 cellar: :any_skip_relocation, sonoma:        "922a4d341435d74afae8ada52f12982965102c0e85b7ef142aedab93010a516c"
    sha256 cellar: :any_skip_relocation, ventura:       "7da6ffa144563c0cb31a4cd24d29abbcfb0f1ace95bfe5e85e0de7a111d0fbb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f6e81b3e14831d2934d6c2ee50d95d17066aecdfd68271ff381878ad310d408"
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
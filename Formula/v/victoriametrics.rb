class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.113.0.tar.gz"
  sha256 "af28ff18bd8503db42156c8d6ade6f6dc18297ac9158b91ad308196cc7c40cc2"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eba9ea17f1e8556e74cacf8ca335d15d901b6cb80a8c48d95c5694a742418d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a468400b76bed2959700f8358ce701d0bca4fc06404e7229cc78e4690f8ff9e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61e07314115f4acf5d1fe6048d1982634b7216e60137efc9fb5484b8893bddb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "674fd1a3d5becb8e3f33a4b2ae983dd6a5cf02d38406aa07eed92a71fefe9120"
    sha256 cellar: :any_skip_relocation, ventura:       "45dd030323f201449ec78c5e2b4b38bc1365eccd2a9cfb2c672ce278f9009ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d0828e162047f3159423e24592b98709e09f294938386432ecd6d19170df69f"
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
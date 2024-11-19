class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.106.1.tar.gz"
  sha256 "e856eda2e9b9351d4a24ccc904a5ad9d70dfb48edf6573d18d49df8976cc37d5"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec8eee8023d2949debefa8fa0977f5234f0e1b02466268bacb462f04e3d823e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f2f90d92887706f2d0ab2ca8af60c8d07da9795f4331a704d945b141c59eb87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73fe34fa232553571e42376e6cd3240d07cd170e950a638a74d4ea82513c8c9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a56819994e70fe56e94d3bb89aa41215c8dc5ae0cb94f7c3845fa9cff62b97b3"
    sha256 cellar: :any_skip_relocation, ventura:       "805df895f864433d89ab3a817074e8f6941f8ccf0589cdeefcf943a6aa7994a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02f8d87a63c6d1334e60b59a971eaec270232edd9d6857ef50d0141438de4448"
  end

  depends_on "go" => :build

  def install
    system "make", "victoria-metrics"
    bin.install "binvictoria-metrics"

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
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
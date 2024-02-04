class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.97.1.tar.gz"
  sha256 "f0a368aaf0245ee46913c934f891422b3b272f39e3989adcc614008734ef8eef"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f315991b73dd8989ea61350de282bbcfe53c6ecc25b51c754c27d3c0bd0419a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85c0899eb3399e77809776570a6d5e37288cb0e3ebc3026a410337f2365b0043"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db88d270f86dbb9f152353e32332b42b812ff3c25955d546081d541882f886ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "e46d863fc6a80c56bd9a7a373edb5ec622e34865d21fa004ec05fbd6e779cb67"
    sha256 cellar: :any_skip_relocation, ventura:        "b2a41dff6689e6a8b2536e48a3b77304e0360e43fccc4fe16af172033d98d836"
    sha256 cellar: :any_skip_relocation, monterey:       "3c46c4fd2b043057d1f1fe3da4ee16a85c24a43c1e40bf5a7e062d29e736f3d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "896c914db6531a55a242e417095c9b88b67103221fddc6c1028502e476372ed7"
  end

  depends_on "go" => :build

  def install
    system "make", "victoria-metrics"
    bin.install "binvictoria-metrics"

    (etc"victoriametricsscrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:8428"]
    EOS
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

    (testpath"scrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    EOS

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
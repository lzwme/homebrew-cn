class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.106.0.tar.gz"
  sha256 "0edf1a1a94494aef2c2fd584f570d760f0e46cdac5ae8a8f0792f41376b7509e"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00a423d5ca2fcb18c3b3af640ff7d28d25c208e5f6eab435b053a62845dda281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1b4f82c55558d90a1cb2549fbcca1952f7ff626865fc8f4a5e4176e98f365ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e49dd9f122ec74e0f4877e099a52845187bc27e0c4635959fd7251d2864a44a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c030bdf9346d1e7ca36c8339b44e2458b9fe2a1c101ebacacce1db07440f8cee"
    sha256 cellar: :any_skip_relocation, ventura:       "a27502cbea80c9e22748b4b5e96a7bdb51bbb405b77c8494fdfa889602c06188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e581031169d679ebb4bac209e7a8f43ce1143077f9340b2d85efb669fb43e206"
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
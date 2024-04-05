class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.100.0.tar.gz"
  sha256 "0d215d8bcff5da2bce97e429eebde4a248cb703ea9cc2a0d5657781cbf59c994"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94eaf5ee94b3ad45bf17bf845cddae15c2ac4817d3b9739c4600fc8f190442a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d393747f0375178318fcb2b0b25db7a4b768b5d2a77ab35a73bdf4389734a9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f362a582520eec2d7e4b68cb7175cefe0d7f3b74d94e5448e57cb66e91da3283"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebd6ce9b6e3dd839295ee1d44116a3426baa9304554f669a854b70136a087ee1"
    sha256 cellar: :any_skip_relocation, ventura:        "cec0636e91c02a81d239345e8019f7cb7287ac7b4e1c0a15f6f2a12485f59140"
    sha256 cellar: :any_skip_relocation, monterey:       "adf9d7c98913d34b7052db2105276e9c6edcbd3447ebbd5c69d12d5e953f37b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f38fc5d845f99464815fc6c226f8244321f1a165951dae3f7ffde7410384844"
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
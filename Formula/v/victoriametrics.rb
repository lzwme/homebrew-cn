class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.103.0.tar.gz"
  sha256 "8c9f77bbdaf4e2d84f9d2971c6bfbf460b8c05e17e164ff9b717224669192005"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fb06e5c07f6908f6cc9f52e6ad77208ae03559b996641a36cc0bf494afee7b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bba9460e2ac6d4f2577fc1bd1bc8590eb4081c82f78846046d1e531d8205ddc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd90e883f6f43de3fe3e1615cced5a391ac01c4f3d9a85d6ddd880d3bbf077f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fe75300d345530c3a1ef86c0407b478f9afae404b995f847e1384687b1f906a"
    sha256 cellar: :any_skip_relocation, ventura:        "71274af1dad014fd4098d8434b8c639b93c5a23203cace77199b1e6f04994ad4"
    sha256 cellar: :any_skip_relocation, monterey:       "6722dcff70c24cf7c0840e430bd3936d07d6dba03c893f5a63b6e7c3c85de0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c2b95743b342258d0115471afcb3c542308b2a252c97ea6edda3cc61fa7dfaa"
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
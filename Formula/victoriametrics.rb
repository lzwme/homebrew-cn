class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghproxy.com/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.91.1.tar.gz"
  sha256 "af78da63f6c6a77db185d821bd5790b8e25d52ec3f3498a1b3d541e3e6856994"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf8c1314d91e5c177d6ef8e0a1cbb3d6cfbc5bcf1e89df2c2570968235fce69c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30f1901cacace56811bfe688c1a6fa90d8e8b521d0176322ff8295a9624a2051"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fc407fbd59e61e2018df0c2277028815f99e73e6b9829aed93e1ac0995a8c9a"
    sha256 cellar: :any_skip_relocation, ventura:        "1c31d4716961005f4eb257a6c24145d4af7323fb93a68569060f8824b8b216de"
    sha256 cellar: :any_skip_relocation, monterey:       "058f8f86176459c4d494400fa2298e77da20d00f8389460c16957f8ba5f5b6db"
    sha256 cellar: :any_skip_relocation, big_sur:        "094843f540de3567a1c64f94db96a68ec2311764bfe3fd461a4cccb7ecf4733e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a89896c0d24991821aa7557eb13855c2ca0ac473c80374b22d9f0266f27a0d8"
  end

  depends_on "go" => :build

  def install
    system "make", "victoria-metrics"
    bin.install "bin/victoria-metrics"

    (etc/"victoriametrics/scrape.yml").write <<~EOS
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
      opt_bin/"victoria-metrics",
      "-httpListenAddr=127.0.0.1:8428",
      "-promscrape.config=#{etc}/victoriametrics/scrape.yml",
      "-storageDataPath=#{var}/victoriametrics-data",
    ]
    keep_alive false
    log_path var/"log/victoria-metrics.log"
    error_log_path var/"log/victoria-metrics.err.log"
  end

  test do
    http_port = free_port

    (testpath/"scrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    EOS

    pid = fork do
      exec bin/"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}/scrape.yml",
        "-storageDataPath=#{testpath}/victoriametrics-data"
    end
    sleep 3
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghproxy.com/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.93.4.tar.gz"
  sha256 "7638666ce43958d670bcc2ba9944bb971ee6a3a897c1b2b4ca4cd31155298a17"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f38064e69d4f805002c7e8f9a725107bca5cb4c3cad01359873d359281bcb964"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d817f195dfcbaa8fb5be5e1bfcbf3897e1242940e9d895ce06775239684c8a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16cfa631a73dbe80898319dcf8cd04584164cd239a8d56e023757ccc4481ee47"
    sha256 cellar: :any_skip_relocation, ventura:        "fa9d54f8124fcd6752dd1075feb46a799c2257f3074b946c254a252d9db5b295"
    sha256 cellar: :any_skip_relocation, monterey:       "405786c663564528b75e40fac1cacf536d45a15a2686f4b03539d75cd75ad463"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a29c45ac133ac80ea588a659e919589d85e9756e209785c7e5d804eb0957211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f51d951e2b1c0017d2148be7cd26d2e6230e3d4591e4a88f627922a5505281c"
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
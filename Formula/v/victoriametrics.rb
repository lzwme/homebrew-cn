class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghproxy.com/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.93.2.tar.gz"
  sha256 "71498c4ecb24f5473bcddd8f262be2ea2f60b86cff2aa66f7b0d8bc7122f5e53"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c45bd64bbc5393a8ef96ab3dcd89006060a9ddf9ab8ebad081f1dd54d2ff8d1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a4a826b1d710857e2bbc06fc154e41d95456e4f3185f8ecf165167c6ae86687"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c927a769ad240ab596df6eee445af6661aa43576aa3c3a27859f207b06866e1c"
    sha256 cellar: :any_skip_relocation, ventura:        "8cbf9600ea8aeae5c5c8727a912153116445c241a1989181329709515692b2b8"
    sha256 cellar: :any_skip_relocation, monterey:       "e848c7b8e4d7ee6b7ed5929faadf1ae092accc50e2e05f5c95ebd3eb8166f416"
    sha256 cellar: :any_skip_relocation, big_sur:        "66d5527806810f3a37d867e86e7b23a82a99f9884f6ea70a52fb6d5f4bbe4e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61eded4a29603c2bf806b8714d6f426ba96c82552da26855c97b52e46131e2a9"
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
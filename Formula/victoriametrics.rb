class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghproxy.com/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.91.3.tar.gz"
  sha256 "83b91005731979496e48512736606b60a55ba3988ae3fbadbacae6a988519bb0"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f466f49f8193209345e459e3eeba4d94db00f0a3c3c9a7295edb888e50104f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d224242c6a88056cdfee0e16197bd4d8597c7b84f7e80740ebc2228e1f25d47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6a78c4785fdc3feb90a9b65eef063d916f4625f582f63490326e8aea225df8e"
    sha256 cellar: :any_skip_relocation, ventura:        "7e2ed1d2632d06ac675e2eed1ba1bb19316b5b758d6611d5b93baf0160821947"
    sha256 cellar: :any_skip_relocation, monterey:       "6d36d1b095da0823fdf0e9dc5a9d0f24cfa6d54c1f57345e926e95000c6159f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "059347e9526f1d3a23557cf8c9e582f2605ecac748d4b5dfae5b88ff14dc58dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19e864ddab7ca282323c2a3b3d11dae0dda05f7650c8dd0bfcfbf17bdcfadb09"
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
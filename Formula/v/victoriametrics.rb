class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.141.0.tar.gz"
  sha256 "232756379b9293b67527eed4063c01ca4f8899043a50f8b231827cef90d8768d"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff6c4aaca74233fbacd50b86deb30a0a773309d79cdf4e003f56896d063f567"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c63ff67f827d7a3d38a2fe09582de221454fc8270b1f9e356d4c9d61326bbb6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bce18334a4fcdcd0dafdfe8c306bc242c472651e75850c2eed9af754042f1273"
    sha256 cellar: :any_skip_relocation, sonoma:        "76732613d6aafc6f3d4cb3d64b17ec53af60a32cf739be49a8f800b4189773a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fafa00bb2a371043393032fc9982f319b58c48c28ae5a125bdcf5c66592112e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca846e0dfd256228619a3b48064d509f20cb0a2d4e03a15dd3ec502aaae4cb2a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-metrics"), "./app/victoria-metrics"

    (etc/"victoriametrics/scrape.yml").write <<~YAML
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

    (testpath/"scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    YAML

    pid = spawn bin/"victoria-metrics",
                "-httpListenAddr=127.0.0.1:#{http_port}",
                "-promscrape.config=#{testpath}/scrape.yml",
                "-storageDataPath=#{testpath}/victoriametrics-data"
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
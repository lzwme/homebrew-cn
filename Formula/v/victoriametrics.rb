class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.129.0.tar.gz"
  sha256 "f8a44659ac1f94460f2afa55a1e7f832e6c93c6f43a885928edaca3cc198072c"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a5c9ace46b56af1d61c71dd4fba26af14cb39f9bdc9bba3fd73069b0537b69d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "708599e0f66aae028937fc21f5c7198adadc6952eea3bfd49f80be2eec21650a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10af73cb9587a9ff295c09a6c26c1d098a6a05a17657f7e89356f56ac9662e18"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1af1487ac80ed5a2a316bb4879787f42888d78ba5473d8a0c03c10b575b35cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6c19cb79c8a24ca75a707210c11407e5f3faf9adbfc26d6b245c293b389412f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef28cb1cc0a464a3c43c8f52bcad9a0b472eadb4b9ff0eb4ec8d8a68817a3bf8"
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

    pid = fork do
      exec bin/"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}/scrape.yml",
        "-storageDataPath=#{testpath}/victoriametrics-data"
    end
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
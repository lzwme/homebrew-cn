class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "2b759f480fbb9bb756d051e2c6c0bc5f1a6bfc3720db734b6b5be7f4e24f45d7"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "814f39103ddb47448b84b23fc43d196e6ad1b4384c99d580395037831a207286"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "512fbba3a71004600db115c12d370c9e0380deb0677851fe9d61bd410e95716b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d15dad054526d8933321c434df070588652128497e8eb346780948ff4abe05bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b962b9c533c4d5ff807c636d6605b1489f572ed120e0604cfe33cc03e09228fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76a46a8d5cfedc9873513373b123d7ff3cc8da685becb5058447486194e9415a"
    sha256 cellar: :any,                 x86_64_linux:  "2ff76e0db919004040e09193c845207fae2e934050795fc5fd685886130eba8a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/prometheus/common/version.Version=#{version}
      -X github.com/prometheus/common/version.BuildUser=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    touch etc/"node_exporter.args"

    (bin/"node_exporter_brew_services").write <<~BASH
      #!/bin/bash
      exec #{bin}/node_exporter $(<#{etc}/node_exporter.args)
    BASH
  end

  def caveats
    <<~EOS
      When run from `brew services`, `node_exporter` is run from
      `node_exporter_brew_services` and uses the flags in:
        #{etc}/node_exporter.args
    EOS
  end

  service do
    run [opt_bin/"node_exporter_brew_services"]
    keep_alive false
    log_path var/"log/node_exporter.log"
    error_log_path var/"log/node_exporter.err.log"
  end

  test do
    assert_match "node_exporter", shell_output("#{bin}/node_exporter --version 2>&1")

    spawn bin/"node_exporter"
    sleep 2
    assert_match "# HELP", shell_output("curl -s localhost:9100/metrics")
  end
end
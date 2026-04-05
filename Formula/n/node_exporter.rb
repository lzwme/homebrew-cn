class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "17728be6a733072e4e3f60b0cdd4821d99a483d737e0f84f4db7f23599ebe137"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3da123b95ed947817f2944faa9b891395d7d2fa297e37770f854ac8f71fa5f69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b15880b34a58bccfdf002ffc91b5ade1b261f37b72270024ace65098cc2d8b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c58ebf5eed0d50ef3913e4ae3886aa042a0cd63e3322a27760c751afe9658bd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a3f493760ce3328132891c13c89472b18c7bd229cbf5908915130a2c17fc80d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adb32857fb74056291f0954cd66a6af71a29517062b76c2a03ded006d4232891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce83bdfadebf680e55fe7bc929ff0b3a64e3c9e198d3f412d6a87e4e32b7c2cc"
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
class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "247abb555f3ffc7f194d2ef71b60b0403ee296df2f6883afd33e97bf57214303"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f07cab1ef410aa386ac7d5dbdae56a7363f6298e22e0b8973f8f861a41b5ff35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "292c6f04f46c2b69b63751a41ec9a655e99ee9c76292a6de47938dafcdbc45a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2950880ae1912b121792c883c22f4f13d0a02821b63198eb8c9f0b234940c5e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d7c2cfa0843c334804050a1efd1ba82ef64d1142eabe9b2d39ca6009f14f66"
    sha256 cellar: :any_skip_relocation, ventura:       "346e02a63e009b50ad16f12ad0061699875e08858ee0475b50ffbddce937eaf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c1630f0acc8623190dffff9e1b7c002741e1c968ec9eda781aa2049e38eb793"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/prometheus/common/version.Version=#{version}
      -X github.com/prometheus/common/version.BuildUser=Homebrew
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

    fork { exec bin/"node_exporter" }
    sleep 2
    assert_match "# HELP", shell_output("curl -s localhost:9100/metrics")
  end
end
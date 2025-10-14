class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://ghfast.top/https://github.com/cortexproject/cortex/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "f60a9584860d8e38333aa3914024ce09ee470397fdca9c9f3b22dac7f7873a41"
  license "Apache-2.0"
  head "https://github.com/cortexproject/cortex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b62776abeb120125c7ea599f3fc47c7d7228a9b2f60111aee5ebb5bbf77e2571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b62776abeb120125c7ea599f3fc47c7d7228a9b2f60111aee5ebb5bbf77e2571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b62776abeb120125c7ea599f3fc47c7d7228a9b2f60111aee5ebb5bbf77e2571"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaa377fe286bbe156180c732c1195df0a09e7905a5557ea73f1d7e2e2f9d94b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "849cadc60a79f7fac521fcf187b5bdcea6b5778bd1087963ca42d424ddc66d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f14f66931599bc196ad88eccf933599f6d0e69104754f48a3b97ac3839b87ec8"
  end

  depends_on "go" => :build

  conflicts_with "cortexso", because: "both install `cortex` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cortex"
    inreplace "docs/configuration/single-process-config-blocks.yaml", "/tmp", var
    etc.install "docs/configuration/single-process-config-blocks.yaml" => "cortex.yaml"
  end

  service do
    run [opt_bin/"cortex", "-config.file=#{etc}/cortex.yaml"]
    keep_alive true
    error_log_path var/"log/cortex.log"
    log_path var/"log/cortex.log"
    working_dir var
  end

  test do
    require "open3"
    require "timeout"

    port = free_port

    # A minimal working config modified from
    # https://github.com/cortexproject/cortex/blob/master/docs/configuration/single-process-config-blocks.yaml
    (testpath/"data/alerts").mkpath
    (testpath/"cortex.yaml").write <<~YAML
      server:
        http_listen_port: #{port}
      ingester:
        lifecycler:
          ring:
            kvstore:
              store: inmemory
            replication_factor: 1
      blocks_storage:
        backend: filesystem
        filesystem:
          dir: #{testpath}/data/tsdb

      alertmanager:
        external_url: http://localhost/alertmanager

      alertmanager_storage:
        backend: local
        local:
          # Make sure file exist
          path:  #{testpath}/data/alerts
    YAML

    Open3.popen3(
      bin/"cortex", "-config.file=cortex.yaml",
                    "-server.grpc-listen-port=#{free_port}"
    ) do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute_match "level=error", line
          # It is important to wait for this line. Finishing the test too early
          # may shadow errors that only occur when modules are fully loaded.
          break if line.include? "Cortex started"
        end
        output = shell_output("curl -s http://localhost:#{port}/services")
        assert_match "Running", output
      end
    ensure
      Process.kill "TERM", wait_thr.pid
    end
  end
end
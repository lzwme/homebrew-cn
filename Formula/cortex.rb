class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://ghproxy.com/https://github.com/cortexproject/cortex/archive/v1.15.1.tar.gz"
  sha256 "003e8ffbfa6243c31a04f0d452a99dc912d0aadc8a34905f1a792bf1347f51c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a06e836504afe7da9a56c6dd9c4313ad5eea3ff65421697169f46ff78c8c2037"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a06e836504afe7da9a56c6dd9c4313ad5eea3ff65421697169f46ff78c8c2037"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a06e836504afe7da9a56c6dd9c4313ad5eea3ff65421697169f46ff78c8c2037"
    sha256 cellar: :any_skip_relocation, ventura:        "fe9d447ee9e9ec5349b198741255771361e92689292268e893c4a4d968af578f"
    sha256 cellar: :any_skip_relocation, monterey:       "fe9d447ee9e9ec5349b198741255771361e92689292268e893c4a4d968af578f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe9d447ee9e9ec5349b198741255771361e92689292268e893c4a4d968af578f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb7faeb11b466062871c988f9e20b91ef6e663d0313bbdae8d0f3105cabc059"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cortex"
    cd "docs/configuration" do
      inreplace "single-process-config-blocks.yaml", "/tmp", var
      etc.install "single-process-config-blocks.yaml" => "cortex.yaml"
    end
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
    (testpath/"cortex.yaml").write <<~EOS
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
    EOS

    Open3.popen3(
      bin/"cortex", "-config.file=cortex.yaml",
                    "-server.grpc-listen-port=#{free_port}"
    ) do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute line.start_with? "level=error"
          # It is important to wait for this line. Finishing the test too early
          # may shadow errors that only occur when modules are fully loaded.
          break if line.include? "Cortex started"
        end
        output = shell_output("curl -s http://localhost:#{port}/services")
        assert_match "Running", output
      end
    ensure
      Process.kill "TERM", wait_thr.pid
      Process.wait wait_thr.pid
    end
  end
end
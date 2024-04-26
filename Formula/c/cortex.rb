class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https:cortexmetrics.io"
  url "https:github.comcortexprojectcortexarchiverefstagsv1.16.1.tar.gz"
  sha256 "07cbfbefea937bb9f77dde16a6eb11861607c6d862a5851383576b5ab755d113"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "958f576b14665c8b02261422bdb6c917b2aa9eb6337e45ab8e6a3d133e7bcce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9f84ef292a5088f75af75967ea63128ab31843b34b2a61dd438641412deb0b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4618cfbe3e5ea31e373f1e684aceb91cef75e8a4227c80b5be61ad865f560f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff3b3843de75d366e3eee2ae29e254208f2c71febf498e8f33568c7e1093f284"
    sha256 cellar: :any_skip_relocation, ventura:        "ef5b14d0eaf5333d2c62100803587888ff9146baa57389bac093d08e048d70cd"
    sha256 cellar: :any_skip_relocation, monterey:       "1afe6dba231e36a91a7c67246e1df48b984d5f692af4b1db07796396d30fa83a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "864435342a7a689e6d49de4db2fa8cb19331cf347271f99b402d3519db955ce3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcortex"
    cd "docsconfiguration" do
      inreplace "single-process-config-blocks.yaml", "tmp", var
      etc.install "single-process-config-blocks.yaml" => "cortex.yaml"
    end
  end

  service do
    run [opt_bin"cortex", "-config.file=#{etc}cortex.yaml"]
    keep_alive true
    error_log_path var"logcortex.log"
    log_path var"logcortex.log"
    working_dir var
  end

  test do
    require "open3"
    require "timeout"

    port = free_port

    # A minimal working config modified from
    # https:github.comcortexprojectcortexblobmasterdocsconfigurationsingle-process-config-blocks.yaml
    (testpath"cortex.yaml").write <<~EOS
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
          dir: #{testpath}datatsdb
    EOS

    Open3.popen3(
      bin"cortex", "-config.file=cortex.yaml",
                    "-server.grpc-listen-port=#{free_port}"
    ) do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute line.start_with? "level=error"
          # It is important to wait for this line. Finishing the test too early
          # may shadow errors that only occur when modules are fully loaded.
          break if line.include? "Cortex started"
        end
        output = shell_output("curl -s http:localhost:#{port}services")
        assert_match "Running", output
      end
    ensure
      Process.kill "TERM", wait_thr.pid
      Process.wait wait_thr.pid
    end
  end
end
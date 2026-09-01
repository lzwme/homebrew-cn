class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.45",
      revision: "79b87202136cebdaaa7db4d94eaa5915ad381276"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef18d12596c523ed6c4091c8a4c8f8a3be701ec31567a6d6ef2457c9d0f29776"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60f03ac99f4bdf9053d1a1e2a95bf72d971f4bd43a3e87658360173facbced6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55a9fbc393bbd9bbf6e5fd6fa0dc0ba7101655c349c72b4e0d2ce57e6d5e2691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47f19880435bd5ee14aa169f1d33b7e0d5363b2a2ed3d46a12cb6795f04948e4"
    sha256 cellar: :any,                 x86_64_linux:  "59f8caafabf7bc52a116695632f1f3d9ca130bfe6cd55effee0b09a413200a59"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
    (var/"seaweedfs").mkpath
  end

  service do
    run [opt_bin/"weed", "server", "-dir=#{var}/seaweedfs", "-s3"]
    keep_alive true
    error_log_path var/"log/seaweedfs.log"
    log_path var/"log/seaweedfs.log"
    working_dir var
  end

  test do
    # Start SeaweedFS master server/volume server
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    spawn bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
          "-master.port=#{master_port}", "-volume.port=#{volume_port}",
          "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    sleep 30

    # Upload a test file. Volumes are created lazily, so grow one first.
    system "curl", "-s", "http://localhost:#{master_port}/vol/grow?count=1&replication=000"
    fid = JSON.parse(shell_output("curl -s http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
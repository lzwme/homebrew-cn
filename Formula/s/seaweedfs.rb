class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.05",
      revision: "87b71029f75efc2fe6f1bcf12a3f129127f04e90"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93d7d3dffcf4ff78d49a1e509794cd9334e8864c6d8e71a90237c6206e2c2f6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ce308c5ace0210efbdad14ad4f2adfc7a5ebe0d83d0f4a0c56df65a49692d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd2493ce2dbc79a3e950b978dc052c4ee7d61025c9621a0e05c92ebba0faab60"
    sha256 cellar: :any_skip_relocation, sonoma:        "97420c8483407bb42706caa376301786281fa56362db23645bc210d0460ce133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9a3d35354c798d254923c9dd234628142ce29443e9e9ae1924a1351a6bfe55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46167fb0a01d35e898112037f25720102b38a82b3fe80bb347a00439200b2a7e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  def post_install
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

    # Upload a test file
    fid = JSON.parse(shell_output("curl http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
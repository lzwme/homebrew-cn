class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.27",
      revision: "e332b97d5218c136704977394a5778844da8e0a8"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "062f6d895280715f903626634f488117e85a06d802fb2b7a86ab856a4e8e78ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17af1d561541da60d3653ba849c46b061ff3a22196576093b6ff6f6f6798074b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00ac69fa99992d0fc9ec13b56934004c2e106c3acbcdda0b57d0c0eee0d2d602"
    sha256 cellar: :any_skip_relocation, sonoma:        "1432fb7cbe9dc54ba79315e73ef1f81ceb772b788dd3fc9fbaed4ec26143e24a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d5cc6ce90f0f82b6ac25240dbb0cd910d862dabd21ec37009b98f6c25618c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "350c7a9797d47fad86e3f2e153c5e24331e9909da5beb10ecf8061ca859a6be1"
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
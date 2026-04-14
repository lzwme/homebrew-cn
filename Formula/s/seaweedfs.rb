class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.20",
      revision: "50f25bb5cd02442de1ce7d03996cfa47b872afe0"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b54881b9ef7ad6069fdaff2ad81e6b5494049a5bcc7e5fa51fb331e6440a1aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ebe9e25410a58f8e86312704fd4de710c817f088a21be5118b63a41ee97e34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d78994958363357539333bc56c4e077705c327127b77dfe560bc3ddd191a681d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bf27ec1d065d90e5b32b86bc400c2f2550627ce92c56ecf3ca710ed660dd633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc5ec7f4722276161d209b14b8a4b29b85211dcca52275a2d4e53ac0e1dc5a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50411ef92aa3dbc9740a215d1eac0f100fb655b7668be7c653c24627802accb5"
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
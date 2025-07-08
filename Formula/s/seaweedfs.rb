class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.93",
      revision: "84938714067e4baf76b1ed9dcf9179f6b0ed25c7"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cbd27230f0cca1c6a1b8ade9f4e6cd837fad3df8c3f62946a91ea30d1203abd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87c70bca25f4fc1ba4cfc4dce17cc93bea6de6452e1096622d2b29d5e17a4edb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9ae19b88d1f7888dc9b82c4d7a938a3da667baea61fa6195c1f5f89512831f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4df8de384614bf14679ed85912d0f8288243b778160919712febce101cefcf4d"
    sha256 cellar: :any_skip_relocation, ventura:       "319b5e215311a2abb731e735cce6ec6b01d2b0800bbd96718f10c1dd3b9b45cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd545eb8082b2668b313e554682e3c65f99a4572fc875c10d0b1225c532ba4d1"
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

    fork do
      exec bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
           "-master.port=#{master_port}", "-volume.port=#{volume_port}",
           "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    end
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
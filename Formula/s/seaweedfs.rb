class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.96",
      revision: "1cba609bfa2306cc2885df212febd5ff954aa693"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c79bfd95a36485ebc2ccdffaae6a3d7ed3c8223d2a60326502b5a91694619900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a26b381c8db9072d1a4d65d3556f7276b77a145f39e68c6983d0ddfa811bf97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d93f221a8805b1a5f60e8d1482d756ad019d61af5114fe39e96cae82060837a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d790a51fdc6105882064acc0cfcc71339579789dc7aa955e4d27c2229d24c83"
    sha256 cellar: :any_skip_relocation, ventura:       "fa200477173987dee99c6a20f7c10a96b3ece534a96fe3e2fbfb701c46afd856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "832231c65ad5effad46f67042fb6fd3b334f46ec7ed38ff9d1be9b33676135de"
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
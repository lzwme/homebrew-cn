class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.30",
      revision: "34be9170f0d461bd16ec7458fff106f277c0eb75"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6582c54757add7d84ef2b201429cfbacea8d03656a947ddedd8eaed87ede94ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69040c3b7350744bd0c0b2dc2ed591acb6f5436fb90c67f1aea49e5794ed164f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8e40e6a245d13e61a90b8e788baf865eb78438e17c2791cdd270a8c95ba323c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cb972a3b52138c90c6e79edc28d7a38711b13325a3bcef1d1f3e12581861f37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56c06718552953a79295e49a5cef6294a6679ebfd4f5ea4cdb4ed5100fa2b13d"
    sha256 cellar: :any,                 x86_64_linux:  "6ead55f480dd66abeb64a70d8780b3f7bd4597d85a864f224a09333f44fcd957"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  post_install_steps do
    mkdir_p "seaweedfs"
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
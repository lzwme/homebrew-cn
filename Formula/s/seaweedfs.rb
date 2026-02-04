class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.08",
      revision: "330bd92ddce763649d07e078d550cb03eda6a593"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "beddd0283f5497fc9665b647e530841533f7dc0e38cf98183f087f60b7566bb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c362407c408c879ad5ee31e1fdfcd0ba38cf9b2f15c947f3fefd7ecdb035f6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65c15da42557654e7a69a86cb999e2a771b5d2bb683ac62402cbdaa6781a0877"
    sha256 cellar: :any_skip_relocation, sonoma:        "e85cd2602387f372be047b72156fc0e1db97a18f026c62300055b91c7a9bcf37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "906e4d2fce0a424f4fe3a8b3030a8de0551816a53a8bcb746ce8affc8add8e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee1532b088484aced9feb143b9533ab16efc1a6ba4e97415a4ad07d9bbe39bf4"
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
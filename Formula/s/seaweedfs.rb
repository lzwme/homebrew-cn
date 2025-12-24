class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.04",
      revision: "8d752906012e511bd52c68369bc7c8c8b108b71c"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88825d39a5870041f3295b1f94569e4ed0cbd8dd22eb9327e8bc7fce0b5ce1ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "888b38b48b41ca97313f525c41395c4e654e7734b8e5c07e6f7d24df4c00243d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8088a9600041f61d335e9b23edc860bdac64eb37cdce8ef431b88295df2bf57b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cbe5c49bf32178edd7d1805707a5bdf20e2af277696d1ad153774914d7b355a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc9d077aa06373c780ab013d1d0939d2a7518c8a16f4250cfd5ee6e77338963c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "393c82d36893ac3e100d84b9ad95291257133f9a08b4254ad5e988bb054d74dd"
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
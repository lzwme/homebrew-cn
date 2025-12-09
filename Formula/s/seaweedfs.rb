class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.02",
      revision: "805950b401f9bf52424a6788c239d42dc6e1c666"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f4c294cee865daf6368ada1a13e410cf3bfa4aac67ec25679fcd7fa50f5f415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d3f223e2ad96f998b5d0f76ee4d46abbadc6d60c653ceb84a9c435f07df0eae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee44b17d9d1143c06f7962eaf1bf5943a13c57048d002dfb84110a3d6fe392a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "738c7033abbaacd513d32ce7c064ab6f6045cdeb4eb847c71c73e770f4d8b997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82244263b5a5dfe1e0f4553bbe27c1a8139638386036508f9a6337608ae98989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cae0cdd8d9e184fdc034f621db90ce99102bae84c48c9bc0ae6dc02bf54a08b2"
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
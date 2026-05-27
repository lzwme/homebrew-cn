class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.29",
      revision: "1355c7a102194d6c461baf090eff50367b575afb"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b798038f6b91169a137d8f18b042e4f6470315f3bc5d7b61f0d9718dbce355f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bc126866ece7965d9218b7bd3e576aca4b7b283d15d6799c762eec49d057ec0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f07dbbe19befc61664ff1487e42a4f9ead4364dfbcf571b5581029c499c8a2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "67006789b0b2f141f5c459158da6f2d64b6cf688817a94ad943e2de155b238f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87dccecadee73b7e2c856b5f1c1a2a2d4be6c4fbd74630855b5cd5b8eeaa2f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4c46eb67bacd3f826dd217b30f6a783a6f2c97452ce1b2ebfb2e0f987d03aa"
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
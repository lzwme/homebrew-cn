class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.41",
      revision: "de34a1a87c02893507f961cda9574172ee5064e9"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93a743d5f14f80c9caead0da0bcbec14e19a42bc5ced5c4e64615ee7e0bd4134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a22306bb88f5bd679a9a18c344a67ddbdfcb9dfc5af33eed674be579ae948147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6c0eaf381d7a0fffe1644a3004c6d3a027cf74b411ff34810603630812ca335"
    sha256 cellar: :any_skip_relocation, sonoma:        "e77e64da14832c229b981165b96539096c789d13bb205a10eea76cf2e5e8efa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66d687623f6d4920a07fbac91caeecee26632701c3049f3fc0817dbe0ba310f0"
    sha256 cellar: :any,                 x86_64_linux:  "43c224b5f476957bf966bf5312c4c036f1f6b9a3b09b78352b43b381165b26b4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
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

    # Upload a test file. Volumes are created lazily, so grow one first.
    system "curl", "-s", "http://localhost:#{master_port}/vol/grow?count=1&replication=000"
    fid = JSON.parse(shell_output("curl -s http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
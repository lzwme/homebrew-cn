class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
    tag:      "3.58",
    revision: "d1e83a3b4df0c515d0aeb75dfbc8f398a771a90a"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b279ed52102178b73599785df9370c22b362788b8bda5f3a6441ee25d71daef9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcf68b9497402bfa9958f62ba877d7e31b9139a6d93f048ba78c716f10f0e68e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "784a0612c6287b44f0e0980d2f935d1351ff5a8ed58cd2c71a5e7d7b7e11cf9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4bcc1b39b8379b47d0063d91e6573e15ba399cd6c94d23309bcaae3a9790fb1"
    sha256 cellar: :any_skip_relocation, ventura:        "3dce619a1b1ada3e46afd3aa9a6d8acf125877ade4ffc444850bfb8488bc988d"
    sha256 cellar: :any_skip_relocation, monterey:       "754a27071a973b4250283a4255329cca832de78920cded7a43f7a64383c1cefc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3b2ed56ab9927adffc11b925167a265b006867740eabae16233419a732ea301"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"weed", ldflags: ldflags), "./weed"
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
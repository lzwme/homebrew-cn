class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
    tag:      "3.56",
    revision: "5407b8676669a8e6389121b37800301b5e5d4dc2"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2833d3c8e39836ba827b9906a95602fd2195f648868c5d26a168ed452bbf531b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "201b0c2d27267484cbe933e7c5ffc98698f4d95c666a123d0fb9276bc2b7db33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cb771dc18d167e017e722253937c3a1fbd983532962c708cf26dabf7469de13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f44c4b0ce9c0c82f942c2304e3be6174bc6c6e36b4f939e2fb545e7294801286"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f9f3c03863a5d2882bd7f83e54da35d24719f1cd58f4f9fbb338290cbfa8808"
    sha256 cellar: :any_skip_relocation, ventura:        "4ca64785cf758b564eedebe5c89be475f313a367899ee3f5308374287f59cb72"
    sha256 cellar: :any_skip_relocation, monterey:       "22e632bc354b8741b99ccd51fe26cc21e875c14846f8b8ee9c33d3d38cda2223"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0f24439bc633a72db5f1755152588ef9c768718a9363b79326a82d4738cfe58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8045541ab10474e2aec72b0e2d5aa585eb70c78585722274d2943713c2b508c9"
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
class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.15",
      revision: "230ae9c24e1b2665c8c8e9bb388038d2f31915fc"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c6146831464e1ce5ee466169fa8bc9921a0e44da89dd43e80d0da39b29825e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2517e117b183aff5b9964030e605a16c12743260c702405da1802225d3471571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aa0b3510cc3f8197c07411cb0db20b5c7c9b8af10de6cf482f5e743efa09df2"
    sha256 cellar: :any_skip_relocation, sonoma:        "33763774845f3f019d68ad326537266a76de3b759ee16131550a2d7ec2629ba2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10797ee312f03b656aeff3e4aafbb973899d8a8bf3abc2ef6da24b22fae2ecf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d275c17e293154f0761c149894047e206a9e08f2a7edf95ac82d393ec17b8d2"
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
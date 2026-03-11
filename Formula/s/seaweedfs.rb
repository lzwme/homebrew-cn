class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.16",
      revision: "3d9f7f6f81a623397c0a0b70606598b269de97cc"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2f5f219af5864622a125feb9dbe018ecee289821584c6242ab21f098d0ac25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "531f20309af74b03c8dd10ae3e149ca54ec93319bd49384c60cf428d14f626f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d50713931395cac830ad3be8911bc68a79d04f71cb048a9601f7980c7b67f2cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a98640c19cea7cbaa6f89dce298d01d1916413b45994152ff792fe2c2a0cc6ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53fa2934e9b5525e106d8e3de8e0d62c4aced1eaf1e8065805a5c1de18a69e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d90cd041aa458e6449e4700e5315da50b1606e14a8f66ffee324bd13b84a965"
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
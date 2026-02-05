class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.09",
      revision: "5a5cc386924087f06ef451006ad5d8068576b93e"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9703ea38ae9610a5dde7f73373d57f53c6c3f11a8311a542d77c9d94cda3cd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42816856cbd631b8f4b822d0e70b665d5c3d9e3cc4742ed23d8fd72fe24b9034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43aacaf6756caf3aa9de78dc1293214e18b213cb776e2e6805a938754a62b902"
    sha256 cellar: :any_skip_relocation, sonoma:        "41c3a55a360cc26ac54febf454a028dd1d7ec4299a00c96c8587020cd9b6a817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac3272dcfb0d8766e89acf4670636323c093afcc2b4e04b55352674cb062494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d765cfa20050ec169a0d02cc0b29cf6a630ea4c65949bebadd553b77e9df8902"
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
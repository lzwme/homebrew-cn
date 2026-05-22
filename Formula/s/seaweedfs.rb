class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.28",
      revision: "adfd731bb8dd68f320bad7943717dc11721c16eb"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4624ac0a7296cab46278d53acbf6832a4efb95ffd712499d47b6e6abfac3d1ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f35f552c03307f74ff79aba54300571afdceb8f2e201ad3aa7b05c7769eaafd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "218cb63e2c20825eb859ea34b9a0724428f3ad4c07cd2521d596b1df4bc0c8d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b971a058e5e0f8a7a88a34bae0307e297e0c0e7fa415f9bce58636fc766e347"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "751c55a06aef19ea531fb6fa7f5d422390ddcb6d61101cc516aa36c90c751407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a57dd48c86a4f665b9abfcafad38880643c74e20b8f9420ef0ae8ebc3c3bc3e"
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
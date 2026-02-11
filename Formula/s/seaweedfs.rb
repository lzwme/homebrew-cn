class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.12",
      revision: "0b80f055c285481eba4ca62ebee7341872c81092"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bab9e723053ecf1f60f45cf7fd49fbe9912050b4179b6920ab5ccbf3f31c7970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "243bf405e25e0da5eefb9809b7c00c09435e8adcb681898ffa8ec20cddbd8d8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87a47c4bfea63a8d877129e73d2202835864ada5199f7cf9d3cb9e3722e2c51e"
    sha256 cellar: :any_skip_relocation, sonoma:        "71864c59ecf54ab47708b3fdfc915be8728ddb50093d4e975966c13f5a263f6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9671647e4a52d61d5fece65306420cd196263757837e62f2ebd48758fb1c978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efc3c5887455c2458ac32206754b4c4af92775e187b03190f1e18432e2894cf7"
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
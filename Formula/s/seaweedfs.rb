class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.98",
      revision: "76520583c6669f3be56e41a601f550f86911d8fb"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4be1e2bc717ace5b0ff5bf921d804a2972173190eeb8b37312ea6f6cacecba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f46a74b5459526ad27a3d187460ca54116038cd8c57bc4aa647cc3cbeda93816"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4896cb2b520e72f283c881cfe011593ee88733c15760668c9e1556fafc50503"
    sha256 cellar: :any_skip_relocation, sonoma:        "09ca1546af2fbcd61a34c4534225704c28c5c5d8752e426ea78d668b2683c1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a01171ab42fbedeaef861d2e73a6857b8379b3a22b81379eed43f1f923c00e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80e93fe43959fd3a8d6bb02203d670125bb14d20f539e501b663f9250a221592"
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
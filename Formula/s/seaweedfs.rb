class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.11",
      revision: "30812b85f3b542aa6d14cc2dc1844fd1da0ae7a5"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06dafa166ab7349e888adff7abf59f545a210713e5f8a9526db04bd0840040db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5f09595e41b5c2247eb39f2cc6a6ffa1113c635af7bf590aa6feb951f3fc7ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e71f41693df5f80871e51c349cca98eb4d03489016cfd98eaffec152fa7ccdb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e79d6d904d1920f1e5f31a069dea44b5687e7f0525017c8dd05206fab6b8346"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e550fbeb72f5dba9ef43fd9f6c34cd32ed992441155d73eb476d4efa5ae1cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ebebe8ac95c59680fd3847475fa6fbd423544f12879489e934fdff5a24b7cef"
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
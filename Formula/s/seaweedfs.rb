class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.32",
      revision: "78da9572aee7589f773ca09a987b494888829ba3"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bde126f5f98ff2c85d583c8dda003fd271c0ca6add2288cb3f8facb2b6d09d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "847ac396056b83a1806d6c8a156773d44e37c9791631e63027b040eef9fd6257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8d9b4a6d02914f608e3f80de0199afbbaa5e47e76c198d5c040d23ae599f973"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3994e209b8bf5c348bd2d2784cc42d6191c12c4095beec75bc3160376985ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f435d0442510496a961c6881c2fe1e9ae0ab999e20f3d8ed828977dafca9644"
    sha256 cellar: :any,                 x86_64_linux:  "3f22f85c64affc4dde8ae0ae1a80fcf019039cd0e8b7f3329ce385f65a632d46"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  post_install_steps do
    mkdir_p "seaweedfs"
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
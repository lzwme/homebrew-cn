class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.03",
      revision: "bcce8d164c5387608207e4e935f24d6ca4a95f6a"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f26b7ffbcf893b9c4da9ce63f8b122490b0e77d2709bf7018a20a44d6007d3f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5fe7f96e27290d75cbd5498dc1c634ee4891e3e02ef357ae7038f26d22b2bb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd355144a7b7fc04c70007afeebdc7fe71c880efba8de1f20347950f32bb712f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa543c134c9796414002fb2a7550f744c8e25eed541ea211da5e58eb428bf23c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f2c42d4b8ba81bba050cb18f0a5986f8d8abf3f5e36605cf1d8745e79ef745f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46d502a6aa8db2780d7faff70d7ff64e86d6b9289299cd57eaa09d7806824135"
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
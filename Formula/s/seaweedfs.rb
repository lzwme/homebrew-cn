class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.34",
      revision: "c6cf5a5bd7c87694c8d71ab41571f1412170ab2a"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f546b62b0c42db218fdc051a0eb81f6473d801bc7e760754e9de888d1ebe54c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aeda0854479ce74544395abb8292c97b4d3ef0d6a515a26b8d6d7bfac3c898c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99c65018de9c87962bd71477c0a68933220db2c8cd4492374df8c950a3b710da"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af1d1743fd9e372bb92bfe97da3c60189a0c05cef8296f908e399725d77e0df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f82932dfb2df58eaa2dab4b201b5d76dd92f3cae32fcd026f795ccb80927519"
    sha256 cellar: :any,                 x86_64_linux:  "25d2ccf7023e56ea26d3d26114a13b7b5ec73310d6f8249ec05ddafb44c535ef"
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
class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.37",
      revision: "c06a2dca879cdbe742246d812431fbe2de01357b"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a0748919c62cd0f92cd192112acd74adcb7095a2114be6f2ce5093bf6e7891e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e2155b10a18123d060fec7e3b73b3bd725dd3f3fb7c78d7eda1ac7c99c7f7ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aac7bd448a3aaeaf5a76bff41a2e94143939c5d34e7ae3c6e5dde652543a3574"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff45573439f760dda41404ed28f1723bbc53621f35f1b0346dbaff651f3eb22b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1955e877873f541f42909a0d22ceba8873e7614b1eeb6a09ab58fb2aa8d1f31a"
    sha256 cellar: :any,                 x86_64_linux:  "ef78465aff0b59dca62a7e353b0d46593449385c4749a29dc3565d4cfa658fea"
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

    # Upload a test file. Volumes are created lazily, so grow one first.
    system "curl", "-s", "http://localhost:#{master_port}/vol/grow?count=1&replication=000"
    fid = JSON.parse(shell_output("curl -s http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
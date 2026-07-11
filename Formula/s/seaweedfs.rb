class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.39",
      revision: "db42bb49757b459551607939807017d7a9d5a94a"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b93247ac4602aeba73ae94e2fc16eaa81139f5bce93be4f75ef901a3388df41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62a9e1e35830100d4242c8e6ff8bd3d7fb617ce58db4f7d1976e4a839a680e89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42f3302521557c202ee0ce26662fd7e8082cf47900d5f17fc26fbdfb643b54e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3319690a8b2f677b1010a8540a8956efbb305fb3e83df0e2615e63cf3a1d28f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80c6b5446f057a7536ec943001f754ad1d0e25db2203c110d826d22040332e17"
    sha256 cellar: :any,                 x86_64_linux:  "f5ddf23ff95fe2b034a48bf1a75b261adc6fed6fdc52ab427ac56ab31c859e66"
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
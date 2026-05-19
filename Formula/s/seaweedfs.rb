class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.26",
      revision: "01b3e4a71cd5c4a64765f1ebca97a98cf55b571f"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "002bca99ccd21ed9e7e1991439f988bb3be8b84877da1006c46e97090ed0244e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a9e0d6c43878bb8c46c1a34007106d4752387d8315fa0a5d648aebe2e975d7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4571d982c32dd89a5634c55bf4d1186252e41540d2907b4bad9b1c3c6faf10"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade60eb9b9cf43942595c8e075af5ff55b421818a9d349f6cf2b93b693460179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfdf9e158501d8c74078a10086e8863a44dfa51f9aa270c8b6624a15505c533e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b5f761e84238fdf0777b5197b158377993a6895dd3944aea966cd63348fef42"
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
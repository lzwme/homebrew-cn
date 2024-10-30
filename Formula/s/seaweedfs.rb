class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.79",
      revision: "228946369cad29ee8edc07a42a2e0d218ba16d0b"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bac759457746a4a0ba88c9babb337dfbc7e81d9c0ca93cb724ad47bf489dba1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01f7439e1f9e9ba794cc19cf9e5ff695328d6d438562dd259237c4ef35a74434"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a745ce67f61d33f51124f6e246e8265d25f157469e05782a714ddc920fa16428"
    sha256 cellar: :any_skip_relocation, sonoma:        "27a312442eeca85f90a97cb3b8beb407ef86006c342b6a5551aad49568a19d9b"
    sha256 cellar: :any_skip_relocation, ventura:       "441d3d79a6c2973d714fb0c4f040724a0da0d04cf59d30db9bc83c7fe50426e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef5a320cde875f94c319b192adb1f3b8d24132307e0e7f34806b5908be71468d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comseaweedfsseaweedfsweedutil.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"weed"), ".weed"
  end

  def post_install
    (var"seaweedfs").mkpath
  end

  service do
    run [opt_bin"weed", "server", "-dir=#{var}seaweedfs", "-s3"]
    keep_alive true
    error_log_path var"logseaweedfs.log"
    log_path var"logseaweedfs.log"
    working_dir var
  end

  test do
    # Start SeaweedFS master servervolume server
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    fork do
      exec bin"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
           "-master.port=#{master_port}", "-volume.port=#{volume_port}",
           "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    end
    sleep 30

    # Upload a test file
    fid = JSON.parse(shell_output("curl http:localhost:#{master_port}dirassign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http:localhost:#{volume_port}#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http:localhost:#{volume_port}#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
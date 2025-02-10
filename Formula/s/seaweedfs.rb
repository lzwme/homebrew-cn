class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.84",
      revision: "5e46960651b68add6be02d93f34183218d8ca431"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fd88aaf1a1134700f9c9fc6b33b08333fd71ace51b416dc26336daa7e2e14e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f64ebefbbb3bfaf6bc5cabc8e5d8db43a16d455ce879b840c62148ec02bc585"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1366063897269471617cdec04a465ab0fb37a0142d1f4be595fd7e611c511013"
    sha256 cellar: :any_skip_relocation, sonoma:        "be9e793affc8808a5f414ad326b30872fe8106ccc7e12e78904c0e56776507c1"
    sha256 cellar: :any_skip_relocation, ventura:       "c4489f33397700e2e81cb02fdc15f1a8265cfe0a611fad91f3b9192599f359ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a480ce75234c0a826fae0847e33e70bea260ff7eb0d2f4ac9772382da797ab5"
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
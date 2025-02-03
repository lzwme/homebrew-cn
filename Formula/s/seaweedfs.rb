class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.83",
      revision: "5c3d7e6ae63e0e07375d64a9926ed45b536f671c"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a6bd83c154f22e9a93e9026cf80010059beddaf398bb57b52a6c2557cd9f807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b79429e12f45d38a605ff1309bb28e41d4feee68b8b96d0c6b85675d57525d6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0143afe5fab04851bce4aebd1c975f81870b339f36a358fa6d03bc56f994cd2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "82cd07a7a84320e2cad51dfbbd1ca7c4b1b1cec6c84da2a6c8c42f067614aba2"
    sha256 cellar: :any_skip_relocation, ventura:       "4ca19f97991174a1956a9eaff7a200f44b8ae027e800ddfe89c94753994bb3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc7bbacb86817b73eae3c1c5167e0b65cac756617f4059f4f4b0d799b33cea6e"
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
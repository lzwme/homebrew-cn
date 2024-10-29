class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.78",
      revision: "ebbb35d533d183adbd85b696299b7946cc3300d0"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3744665414c025af4490f921dea495562c0f265be4c06a889fcff1f9acc606c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc8331867eb80848817a59b89e5586ecf1b8d6eaf16eebf4035b2b48c7bbd41e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bae415f39af4d85eaea1d14b57adcee637312a74b644444312ea09c03b329a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e207b5fb7073ec72d16ff2fc20d20ec6d83a583e1e4834e2b8736a471fa359a9"
    sha256 cellar: :any_skip_relocation, ventura:       "678de29004b016056861d6152af66bc896f103c56e78d44b2cab5370c6a19211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40486133e384cbf25bc911c111cc38f9f4ffcfad26d9da787c4a1c3044ff2d0e"
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
class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.89",
      revision: "7151a54b28518c93af627911c885f20ad931bc8e"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "737a6da27962bfa7b78a76c7178eac643dc8b34cc559cd482303ba9d57d9e74f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4c98dcc657e7021a388e0b4ba718f6db10e51a73ca59e3f4358f5d9aba8540f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43868be886a595e50fe125f46503726a31e1409e622a236564034693295a93dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "338fc8c435be7c5132107ed24cab5bfb7d5953c41f6ab1b91b321270a583fab3"
    sha256 cellar: :any_skip_relocation, ventura:       "94c660a4f7670f98c114c5d6fcc62d18f0ad323290d563ba26948676b1c73c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7efba33b99f934f11763f6d70f2d1bd56059233036880f5184ce89316c386d4"
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
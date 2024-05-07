class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.66",
      revision: "3682eb929f3e2f49927448d9eed752f48e868668"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "958b60bf619e02d6d1767dd792128597ec541d66a9e5ae59de4be12417a72fa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "359465cd595208e7a6380f3153229db031e56e22510f50c3d85e1fd1aaa9a9fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32cf333d4bf8018a86b8d355066fa2241c67d502fc3d0d73f2d6bc6838b26c1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bfeab7b20863f3a50a5a22fd0e7d9f6d917a6f73a0eb6af389337a1e23cbe79"
    sha256 cellar: :any_skip_relocation, ventura:        "ebca699ea663bd78701cbe9e2f002ae62999e6eb1edff3a5b7589972c99b082b"
    sha256 cellar: :any_skip_relocation, monterey:       "1c1428fc5ed4a1e4597770a6f5428f6ba039ac2a2bffb67fefc7de2e93b66b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f562cddda0084acca0502b9dcd22f3f3002dbe9a62e2e67c33410745df318a5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comseaweedfsseaweedfsweedutil.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"weed"), ".weed"
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
class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.92",
      revision: "7324cb71717f87cd0cc957d983d2ad2e0ca82695"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70fa5cdaff26ab1285e1e23a11eab8ed028ee7a2adbec9ac3bfcfd7894df1212"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b3fe6aa2c3bfcb6bb36c3f72499b5645a8a20d86cf14b4c68d8c2d5ed1926d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b577a0bf124cf8ad2a5d12a102c6bc9febc37b04b008207766ab96b2cfb2e314"
    sha256 cellar: :any_skip_relocation, sonoma:        "aafd538f8985b720afb348f244b1f6450f37b59687e50778a0f80ce454d2e255"
    sha256 cellar: :any_skip_relocation, ventura:       "173a5bb7aab4d0f93af2d7aebaaf401a6be1682a358b5fcd8620d4f5cc6be6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f7c3e10af107801a066e8e969dd97c83c5df8569608e23b64e60d9fa2e1b8cf"
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
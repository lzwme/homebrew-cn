class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.99",
      revision: "4b76b2ad3c0eaf638a52890e396abab383513085"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7f23e66099c590fc7beccb8df2355fe4f66cd42c7b1ce451055d0e4043f148a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66da396c49c3e50c3b30bb71ee28789b0a3ea30080eeeefb697c95e933bda7ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94954dac344676d0e4375ced04b6fb9dde561caaaeed11d907ed32e47b6f6b90"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9253c82558956800b6753c77c62cc7f76b81ff125b1cd65198d0c85e2e6083f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daca0a8f1398f6326e68c2208fdae1cf1e6f175af4be34ce64e6f5294ccaf2b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "154d2dbdb1c75e9052d7d16616c7092b0345ff514433a81e7b68a3e839a2d630"
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

    fork do
      exec bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
           "-master.port=#{master_port}", "-volume.port=#{volume_port}",
           "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    end
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
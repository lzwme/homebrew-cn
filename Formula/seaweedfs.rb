class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.43",
      revision: "3227e4175e2bf8df2ac8aeeff8cf73a819abc5a7"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb81e36bff1d9f5933d079ac96717b06d61a1278b70d3f04a4e235fafe9bed80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ab03611036df3ff35bd97701487658f645176179cf34c8d5ecd2262b33e3a38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f246b51acf58475c85f2a04947cf50d19c098224a395be2990299da65eb4337"
    sha256 cellar: :any_skip_relocation, ventura:        "42dfc31556492be02013e6bbccb5e4b4a90445ba6e918b6b0d9a7eb0b666da10"
    sha256 cellar: :any_skip_relocation, monterey:       "26c62eac8ecf82ab47c2064504630de305689b8adc683b744ea408afb6ea4317"
    sha256 cellar: :any_skip_relocation, big_sur:        "03cc7855708d49c1b15bd2a333e18b11a14bae880b0da4b3fedc6c1f8ec4c539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "148bec6fecb0fc8bbec90350310971743adaf970a92269a2439c9ace3f27c77e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"weed", ldflags: ldflags), "./weed"
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
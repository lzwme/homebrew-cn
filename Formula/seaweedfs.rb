class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.48",
      revision: "42766bccc8db3eb3570b8bf802ddc28a03338527"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38824c90565432310289755d70ed0908af3bc9ddc7923154b685e757ca034f03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7e3dc68d91d77047058ad3b375b51ef222649d4ce5f88867317471abd876591"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "497415b86d8e477a520c85736cfe0e2f45e8b15e63fea13ffd14362c598a7798"
    sha256 cellar: :any_skip_relocation, ventura:        "72861127ec1beddf7a266f0504840bcee7397974dffde3cf1eedc6139d9433c6"
    sha256 cellar: :any_skip_relocation, monterey:       "72682ef6056e2e1fafba27a8a7b2e8c12250a7f7d36ece8f83a007672a17bde3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbfdeb8e422c382d75ef8abf7f55b653bc6940ae7646dd13c0bff67624761ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d15c32091813699641246fddb79c3192526b06419af0939b0aadf2c4a4a97e71"
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
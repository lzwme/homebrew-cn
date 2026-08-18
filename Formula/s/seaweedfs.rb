class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.42",
      revision: "f04da8e9ad8db7ae06bd2caba1b6560b36e28e31"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f4359429bb537f6e77e910cffc1e042f88c4e2b84761c93f1e0ae1d59b2ed94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41f337cb01ab7b15c4135ec08f75920cc06f2f0240bed3c24d97788911bf8933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e4b4eaab65fb35e1f2264aa1945e5cede1c7e9b39ad7c283437a7dddb12750a"
    sha256 cellar: :any_skip_relocation, sonoma:        "03da2479395062349c4aa21ef5ccf1a7b6a439c4cf05d1da1818f5c747c7a730"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b103a83b0cb55d9d5edee76f2ab036bcc2574be2b5397fa3f860e7c28cae6894"
    sha256 cellar: :any,                 x86_64_linux:  "22f30c24c106c39d2736419b0e54d30130277791335627e852f7a00dee44cfdf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
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

    spawn bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
          "-master.port=#{master_port}", "-volume.port=#{volume_port}",
          "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    sleep 30

    # Upload a test file. Volumes are created lazily, so grow one first.
    system "curl", "-s", "http://localhost:#{master_port}/vol/grow?count=1&replication=000"
    fid = JSON.parse(shell_output("curl -s http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
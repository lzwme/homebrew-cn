class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.40",
      revision: "875cd1f67ea25e8965a4f5ba1e6aaf501ba6b6fa"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a3b733d6951c9a805caf9d03d781840396800b109dc99aaa0624895cd35d8e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33933f7d66abb880b17a9cd22c997f00fbe7160a23e4520939f4baf31595774a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09f6c090c0f87177557d47d746a6a35d05fe4b3f2278922d50b3423c7f63a844"
    sha256 cellar: :any_skip_relocation, sonoma:        "15aea986c20ff1b8dac4de10e6e3145dd618cebe6acc806d3ff372c8a6019ea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c4ed5d6839d40c6b9f9c82d9f96791ae334ed0302ddb239ac77f21914b04388"
    sha256 cellar: :any,                 x86_64_linux:  "b1876fedb89f377653c996bf0271da111303a5557a608b24feccbb2a262879c7"
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
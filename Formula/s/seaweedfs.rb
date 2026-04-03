class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.18",
      revision: "6213daf118129d626b0bc61bb432a6445ee91895"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7993c6c7b504f6422f32a7f223ab6713bc52652cf967b5ad80781b910ec9944d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40327ee10c2af255905ee0c5026e13c0571d87608e5c3501ef464709cdb40577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b036a1a3830ebb8c2573044d6f0df346e30ed0755c9b9a427aaa6447c73e1abb"
    sha256 cellar: :any_skip_relocation, sonoma:        "09aab06b2579265dc5908bc391505707b008aafc742539644453c4ed50696b38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84cae066b8383f50fc7ce707448fe5e746de467bbdf48e7d77d9275070f84cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db26a8b3339974805e90d5a14b5e03a3256a7045e4ab3552f3f8130d2ca2e12"
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

    spawn bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
          "-master.port=#{master_port}", "-volume.port=#{volume_port}",
          "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
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
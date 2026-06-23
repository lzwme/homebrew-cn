class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.35",
      revision: "eb939761665ca0ecead5026b02663531ea9fbf9e"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "876ebf91e4cc4610d0255ae18ea1f33f27fdffae8318467581222228463c2ed7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb7378beb60cf7ed3483ad3f55d3ddec8cc287854aef0160652b4b445610f33d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "129e57a750950b89d2780417a4da1856291c8adc3d12ec83f2bc165e725cfaa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7f0e15647d6d68ab2fb28845d6fe145585f23bd51b50825257976cf3f9ed19d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c76a11ee19d5d1e6c37596fd2b7f96e9be7842fe81d501a08a18210260bbbfbb"
    sha256 cellar: :any,                 x86_64_linux:  "64973544e4564411b824d9bbfcce6af950d72fcc4ce541c87a00108807538f79"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  post_install_steps do
    mkdir_p "seaweedfs"
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
class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.33",
      revision: "55010be19b6755d72b4de6ace2072417f70aa72f"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4cfbf661393db5780e6a2fc70988d191e1330f2e84756795f41e9a63902e39a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e616bb401bf68545957095616cf2e934a35715155ca18dd89313a343d01242a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c729c0bca29d3d7adf8118d475b16e56eb3d9fbcbfcd0063c9f72439012b84b"
    sha256 cellar: :any_skip_relocation, sonoma:        "54c01396ee0742288a78d5556b918b8d60976fb738e3bc4f1869d93b48315f00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e7d9a8fefa92c7b13acc4096277f79674834a8b902cd16fd1755c0f6290476a"
    sha256 cellar: :any,                 x86_64_linux:  "6ec35c1a0d21eef07f3f7ade962e087ab0ed01509338a70c21cc7dac27606517"
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
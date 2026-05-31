class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.30",
      revision: "34be9170f0d461bd16ec7458fff106f277c0eb75"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b71782f4402d9c12ac669ed22f0bf90516dc296fa86371febfe841f9f1299c6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3df23d7634bc5f65cb9d64b955215297df63380d1fc50b314d79bcac843af74f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c576ea37e920287ca53b7418869ccfe1ec1f3102040be915abf07a17050687cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a52ee64ee778bbe99ff888986444667db593e322b06f55cca6c539088efc02b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68bbdbf580cf1f0bcc5e8d3934900800778a65eecfecceec78f5969400225123"
    sha256 cellar: :any,                 x86_64_linux:  "d084e2308f1bd318509d43e65f50823edd374e73cf5f7a5363f94d5dce326fd8"
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
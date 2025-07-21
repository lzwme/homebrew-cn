class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.95",
      revision: "394e42cd518fa027cb9926ed7c4acb4f4e644dbd"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa6cbd7b4bf15e968ebd7329413414ea5a5b79dac81def9dfe2ff8aba09e784"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91973e70e23822ab1a17f36f88e7b2de73315b7c536c477b2f0454324b7a6d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be7e5b37693eb1e967af2fe5a1d7639146ac5f36095c9d209856606efefd6276"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c5e54d2c140794722b9bf8fb17e9415a4f5053faf9d77d42ea95829f6bdae4e"
    sha256 cellar: :any_skip_relocation, ventura:       "4e054c60be0e67381807e295a51b147e7095dac52b927e894c21ee9b50f7a790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f62c6828413446a29c2d105e13e2853efd4967da1077e04f9409e199d021e3"
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
class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.51",
      revision: "4310e1fac4e59a4391159e6c349f45a8e1cd0601"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7480016e4b9c25e9af8a7e63d6a70605192ef3fdcdf095fa67e487cbeec52a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abdc88a41f653007ffb3047af32d879854a14e8791b76d72801b5b9b3c9c2ce5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "401377f0f95286db888a2d5d1c05ac3848dc8ec5392dfe9e081bde97d62cc646"
    sha256 cellar: :any_skip_relocation, ventura:        "7184207438a23f0b08b3bf8b0ccf7a59384c2755840e80414b49bae8d8e9b868"
    sha256 cellar: :any_skip_relocation, monterey:       "27f93027c7a9b6dcebce2594dd5928d104f2a34548c396e13eeac90d94659272"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef874f082591868b4ae8795951b647fdab3a5d123bb48be1da29a20d1cd7994a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce8c93a8ed2e94f0de8841ecad4c8292e382515f084b541c5b74467d16737335"
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
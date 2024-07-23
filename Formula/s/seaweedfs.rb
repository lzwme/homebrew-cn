class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.71",
      revision: "ed7e721efe82a29b031e39e37b729a536e6cde04"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a75bc456c7962033f19df4657f2f1e7fc0112f829b9092616410f4d643e824e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c297d0e62d84762b04d6beaff14b04a90dd36d6da03d7c1965264a860e7ee3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7162f3aec5f05a5e3404f7abf89b818eeca1eeeb9f77a19cd1bb916769e8afc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "40888eb0befe569355c6261e89b75a3eb60e941ba769adb67213e1bb378cd1d9"
    sha256 cellar: :any_skip_relocation, ventura:        "7e2e2de7a93d78abd06ecc9b4f29adcaa10f759686a3ec95bfce74aff75922dc"
    sha256 cellar: :any_skip_relocation, monterey:       "b04b213224f01c380eb0b68c50ac463936525393b9f286bfbf9b0d30f8a5d104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a4f08b3d5cef59cd9a9f774562ce19af601b4832b7f69ba424d2740b81af89d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comseaweedfsseaweedfsweedutil.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"weed"), ".weed"
  end

  test do
    # Start SeaweedFS master servervolume server
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    fork do
      exec bin"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
           "-master.port=#{master_port}", "-volume.port=#{volume_port}",
           "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    end
    sleep 30

    # Upload a test file
    fid = JSON.parse(shell_output("curl http:localhost:#{master_port}dirassign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http:localhost:#{volume_port}#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http:localhost:#{volume_port}#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
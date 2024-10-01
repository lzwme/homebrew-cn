class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.74",
      revision: "e3fa87bcc18d3600f9f3b9ef99407509e8ee3383"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d15280202b5acafb09bad71993920b5f1ca31b7b50eb01f12debd465f8dcb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d700b0c666988987a7c0b17d121869bd9942f0be6c679da249c005667123df4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37ee03d69f3517ea857e56637dab688355887c1bc11e41d95898a9b3fe8a8d01"
    sha256 cellar: :any_skip_relocation, sonoma:        "bea239c98fff77701fa249ac623db35abd1db1aa44f943138a13428c4eecc81f"
    sha256 cellar: :any_skip_relocation, ventura:       "7f4f1759ff8afa934132ca56537992553e8c4b550d33c610345bc58a8006aba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d04cab08ee46a210b0d4a7adf3167008ebe6eaa42c3098fa2929d9a7825e419e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comseaweedfsseaweedfsweedutil.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"weed"), ".weed"
  end

  def post_install
    (var"seaweedfs").mkpath
  end

  service do
    run [opt_bin"weed", "server", "-dir=#{var}seaweedfs", "-s3"]
    keep_alive true
    error_log_path var"logseaweedfs.log"
    log_path var"logseaweedfs.log"
    working_dir var
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
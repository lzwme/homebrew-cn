class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.80",
      revision: "7b3c0e937f83d3b49799b5d5dcb98b0043461c25"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "271f6a8fde19005f05ddcee279d13674afb142e9ff1fdc586b91c72ee06fb5ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed39cc69a2aa3c7825e098ca09aa5e93e5a36c038d605c68eafc584d79f78afd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "334a3dced09285e434c82473a154162ca276f49917b649f20bf3502fb96e3ec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed4ac36b7bd6b9c464d55abae5d10d2f7689d4d6bcaa6ca72d526c62f5c3df8c"
    sha256 cellar: :any_skip_relocation, ventura:       "eb936fa22535df0aaa937b487fbf0b6ee91309bd301c584c0e43bdbcd366379d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d4d4009f73a20c7159a8d1bce921c4862b8cf9ad25def529d53138b010edaf8"
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
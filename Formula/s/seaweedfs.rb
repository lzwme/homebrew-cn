class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.75",
      revision: "117c3aebda7906433b4b83419af3acbc47f09f4d"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73dbe2e2105996f4da6cce3da632898f3c398d6e13d171d7afc089cddc72ded7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4f8d4458ecbb4bb64ec3c3ca038e12fa32f65d72b583cfdc274376052e4de1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "565c62e671c171239f1aecfec3f7b3ad3cc73a637818999266327e127ba0eef3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a12a9c99447dbc5486fe1320052856989fa79d4adbcaaaecb105da55b955cb3"
    sha256 cellar: :any_skip_relocation, ventura:       "705a6c2103f209c1d0461f73b3363c1ccc680937b63ba201ffebeb9e4494e0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "132431f9785a166f73f812b286607076ff40512fe52cb172fe378f3af6b4b8ad"
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
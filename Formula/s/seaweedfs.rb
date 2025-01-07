class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.81",
      revision: "39c1dde9df533475e53ce1d6f07996490543fe1b"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e95b90fbd5fd11074548e2fea80934c7767ee5419108a4e817a8fe2b8f50de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d325fea70130e5fe6c5ee1dc64ad87080b3f7f18c4c0f5db632fc94806108f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5efa6a540272e74716394d46e88710160d5c5036eb4da7deafbbd6f608eb516"
    sha256 cellar: :any_skip_relocation, sonoma:        "040f1533a12752970ea9250cc4f11a54093ebe23faeca10e042feb5bf75d321d"
    sha256 cellar: :any_skip_relocation, ventura:       "dd60147996220c6c592184788476d27e48dbe7da7826c67d83923186359bc63e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af1527602563502c898263b189f93b5f622078790d04afa6e6d4e6037eef06b5"
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
class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https:github.comseaweedfsseaweedfs"
  url "https:github.comseaweedfsseaweedfs.git",
      tag:      "3.73",
      revision: "6063a889ed61b4e3ef29360faa5d7623a4a70364"
  license "Apache-2.0"
  head "https:github.comseaweedfsseaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f39b5db2aef10b009955de56d9c28e3ab05995d129514abf746a7456260ffcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98a675b001a67dcaae860b674b2917b7ec3249c5abc8ec1752a109c29d316b1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91a8e5ac87cde446d058e203961f7fc47f1af17c7f2cfc6666012f4d784ee7b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "bebb781741d6675394fd5eea0b3c4bd8ca48717c7dea1bc1bb3ac9b444cd8e55"
    sha256 cellar: :any_skip_relocation, ventura:        "e5fca7c3d51aad6284b1b07424927e99eba62083b7a3efb3c7bf6e6d629a2a1c"
    sha256 cellar: :any_skip_relocation, monterey:       "4336b22680ed592d8dda69927d0d50d60b3c7165347b43f0650d689f1c5e303a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c5205a2bc4723bd4f0fd8e5b2b803351b530f0795701d39e58177466f10b8e4"
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
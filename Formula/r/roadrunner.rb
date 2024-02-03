class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https:roadrunner.dev"
  url "https:github.comroadrunner-serverroadrunnerarchiverefstagsv2023.3.10.tar.gz"
  sha256 "30a6ff870110e50f3014ed3fda7643e4225d58ea3c529cfd1c47c66ed3402299"
  license "MIT"
  head "https:github.comroadrunner-serverroadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e12d0a3fb3dc9d8361dbeedf448e5064064b4fb27c8b66e9af63fb14395e9c6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c881c7cf9f6b78d81e710ae14fad940cd95a3a1d7d2dfc258d164167ad7623e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beba741a56135356fa095d015672756c1ef07e9219c1612cadcddcbfd699cf3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "60cf4e5ca226bfd66a489cf494364f0990ea6055ac8a6e04195921e74ae3ee04"
    sha256 cellar: :any_skip_relocation, ventura:        "b88b890c8f6178c21ab068e1d59eaa8cf883c179a75820f3ae49c506719efe26"
    sha256 cellar: :any_skip_relocation, monterey:       "c2a5d183f088dfa21f749f71d90f4d94a8f4e0f8f6ae55ada67892af0f27cc5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270f37622e0b58757e5cc66a0e2c087c0c028f70e06ed0e1f8fb4db8b1b992cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comroadrunner-serverroadrunnerv2023internalmeta.version=#{version}
      -X github.comroadrunner-serverroadrunnerv2023internalmeta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(output: bin"rr", ldflags: ldflags), ".cmdrr"

    generate_completions_from_executable(bin"rr", "completion")
  end

  test do
    port = free_port
    (testpath".rr.yaml").write <<~EOS
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp:127.0.0.1:#{port}
    EOS

    output = shell_output("#{bin}rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}rr --version")
  end
end
class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https:roadrunner.dev"
  url "https:github.comroadrunner-serverroadrunnerarchiverefstagsv2024.3.1.tar.gz"
  sha256 "065173d0da2eb1206f956fd19c2f05226be287d66783f590861ec815c03558de"
  license "MIT"
  head "https:github.comroadrunner-serverroadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bdb8e35091505a8d85db47bb6c3c5eb1ba0347eca539d6fbdf0818e9272c3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1393f42f3b9d78258f5936d852d5751ba173805507db05b5432644b33854e145"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5597442d2332e1f4dfd15c990a054a00c32be8715c5015db5ff8c5beb725b9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "86ea39d476d3f44709e552a131751f9e2761016374c7f881876e6b1707bf4116"
    sha256 cellar: :any_skip_relocation, ventura:       "1b02613927abcb0dff1225df57df7951b9c96202453c3dee1b200b54df6e5222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e478de4e6419b9fc1cf7e6f296ee5bb24bc500d742cd2761df09649fcd97212f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comroadrunner-serverroadrunnerv#{version.major}internalmeta.version=#{version}
      -X github.comroadrunner-serverroadrunnerv#{version.major}internalmeta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(ldflags:, output: bin"rr"), ".cmdrr"

    generate_completions_from_executable(bin"rr", "completion")
  end

  test do
    port = free_port
    (testpath".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp:127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}rr --version")
  end
end
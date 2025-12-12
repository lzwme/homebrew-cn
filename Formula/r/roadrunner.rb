class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://ghfast.top/https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.6.tar.gz"
  sha256 "1c825bce9a6818ace1c5d3b99e8502a826135da54416dcd710575f10ce05535a"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9a5a69ab2cfcdef5826c852fc5d5df47e0a612c862b7cc7bf87ed4015c554a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf7df461b98b89def8c3ade33dfacf1b89422a4fa0ca7a475c3037d8e9452b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae62bbc2c01c3e7e4d506324070c3b864cce2122a82910ed55e1598a34610d47"
    sha256 cellar: :any_skip_relocation, sonoma:        "3615f1e105aafb6dd1219c5db19a584ac5b01e13afd63134628cc5fa0bb427ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c2d9cef6e9424018e7e5d837ecb3baf03e7f4731e943b6bd1a8ef9d37d4821e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fae10fb7502a6da138a48b2a9e9c1e1b33f0cc4c5059b087fa43ae8c7936a69"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "aws", output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", "completion")
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end
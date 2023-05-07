class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.10.2",
      revision: "724acbef583a65de5234675c1705d188df6c2fef"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b59847c67d6bcb9d382110eea0e5f4df1eab4def930caf482a48c98f3a92383d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b59847c67d6bcb9d382110eea0e5f4df1eab4def930caf482a48c98f3a92383d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b59847c67d6bcb9d382110eea0e5f4df1eab4def930caf482a48c98f3a92383d"
    sha256 cellar: :any_skip_relocation, ventura:        "0c1fe219a7fdf5efb43a78b95d5db8603c5d3885350cfee13ab0539dfc3e935c"
    sha256 cellar: :any_skip_relocation, monterey:       "0c1fe219a7fdf5efb43a78b95d5db8603c5d3885350cfee13ab0539dfc3e935c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c1fe219a7fdf5efb43a78b95d5db8603c5d3885350cfee13ab0539dfc3e935c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc5da2ade6b0ecd1e56c0cda9fe452b336885f9651e203240c14e4e8820c1185"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath/"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    EOS

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 3

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
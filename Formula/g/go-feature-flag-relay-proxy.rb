class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "b63a498677522c6c33e1d61fd6f346b0ccc43761cca65296ff5b927d4ca35daf"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "750513b31cc866ef03f77c3e6e735ea3bd1fb27f6fc212f15385258ed9645543"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26e285b461be2d4c64c9e41f889a9155ebabe421b2264399788789cacaa5d14c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f45761e362e8282210f2102ad5fe51cc5af15018b2c8a1a6e8f25883c8aca6f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a743d033765462673d2ef068121dce63c7b1f4d3b703fcae67e3b1b6913dc8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3085a3806c3668901eeed4a6b6363b2f28103195eb373eee9fb83d51d3465e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55fee953ca7d97348afcee6b56fddd1a9db311cb5efb760604460e280c2e7a9f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath/"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    YAML

    pid = spawn bin/"go-feature-flag-relay-proxy", "--config", testpath/"test.yml"
    begin
      assert_match "true", shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
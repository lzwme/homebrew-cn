class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.45.4.tar.gz"
  sha256 "95383be7efad827f0a16b03687ae59ce0b73772c33d724542629fce17893fcd2"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f44ab14cab54e028150fd63e55ee1cbadf860db331d0c0865300a8b7ec4893b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "455a156c7d864e8a73e8b6554b5ffcf3b8a2bc36115fe31307cd34a8273c66ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "416914d7e487f5d2457cc84e0afe302e9328acc8aaa175236484f14468ab3b9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2960a4b984e634400d033a5c5226b36c9ff9c6bbee65bc9f6b6453d5cf2c0a8c"
    sha256 cellar: :any_skip_relocation, ventura:       "886421d003892d21a3849bbcee51530596b183e57e2a7e3eabc4a321130a1ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abd19e9a0bab91bd080c7dc61517c19e4d6a62e5a23e0280a8a28d67156572f6"
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

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 10

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
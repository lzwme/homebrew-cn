class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.9.1",
      revision: "276dfccb07e921b588f0d8ab3b0b4f6105ab590b"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41a8fbf97535ffc3d3fc9b81efdb3527b22539517ed07c5d5478048a6cd02635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b43826d63c83c6f3d4a98b426133797f6964d75b01836581c918e97d16c642e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41a8fbf97535ffc3d3fc9b81efdb3527b22539517ed07c5d5478048a6cd02635"
    sha256 cellar: :any_skip_relocation, ventura:        "0abbbda20d6902b4221dd7d10114bff9f50842bc7f97111cf6765bb8e5b86684"
    sha256 cellar: :any_skip_relocation, monterey:       "0abbbda20d6902b4221dd7d10114bff9f50842bc7f97111cf6765bb8e5b86684"
    sha256 cellar: :any_skip_relocation, big_sur:        "0abbbda20d6902b4221dd7d10114bff9f50842bc7f97111cf6765bb8e5b86684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f66d8ecea799526c667064dc9060f9e0b8ebf8649fc5154ce69e9e071cd5bc"
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
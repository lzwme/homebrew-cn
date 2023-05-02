class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.10.1",
      revision: "50c5d3980b03f823c811dbc411385e89ac4c3a7a"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32f0a41940fce9905c9c459f32679acd27a305f7f5276021a5d89c4ea461eb34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32f0a41940fce9905c9c459f32679acd27a305f7f5276021a5d89c4ea461eb34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32f0a41940fce9905c9c459f32679acd27a305f7f5276021a5d89c4ea461eb34"
    sha256 cellar: :any_skip_relocation, ventura:        "47e81bec31aeea55c20a03148eed863572f58109d6ee83b3fe7941ebc19c0104"
    sha256 cellar: :any_skip_relocation, monterey:       "0da93b5ebd070ebe70046f65bed1e7b7e25d65c11140006c7b0ed80570350fe3"
    sha256 cellar: :any_skip_relocation, big_sur:        "47e81bec31aeea55c20a03148eed863572f58109d6ee83b3fe7941ebc19c0104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d710a8411c951a5688a345b2db190c2dabd822c6f60e68c58d85d8eb26d125"
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
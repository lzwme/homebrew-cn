class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.45.2.tar.gz"
  sha256 "39b76de5725f9ff74167a8914cf799710f71a5da1449c0a97ac09cab12172a96"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "303239523fb4d6057033ec78626759f7b83a09222e7a28781e473f0c315136d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b44b6d64bf4416938558d52ed56b4dc0f969bc1426087a4b581f5658f3ceb09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04460ac22da01e49edc0016973e8290bd9b71d913b4cfcf37236284db1f441f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b34fb322ad1f45ccf46fd1e697da6820acd2cda87f44bf27fdc70c2c4211e7c1"
    sha256 cellar: :any_skip_relocation, ventura:       "83a232f830ca43a83774ab0e936f94cbc2bf93f7e3bbef1f7b789b8a3b111aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0c79252b5ff8de76b8293382173c1e2eafcf1faa5fd7ddf63fa1149250cd93"
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
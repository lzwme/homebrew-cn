class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.45.1.tar.gz"
  sha256 "dfcbd3a6480382eb2b99c4f702c29bd08c5ef3d4cd8d9ca6bcf56643e97a5fbf"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4635fdeca2243911f8f58394928d91308f0d58c4fae6c51644d5ce8088f064f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62eaef57c4335ae0e02f76ba2fa48a09a3c5da733fc5bb0f4eaa2d6c85e73397"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c896dd316bf7902e0d68fa21f176461fad92c611a5ae0c902500f4c965df5b01"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eaeb0fef314834a632572ed67141a127306414008b209b5db3339f8f36ff6fe"
    sha256 cellar: :any_skip_relocation, ventura:       "22da03dbdd84da4eb0526fa0321b044cf129c9fb5634c277baf4aa8a328984f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad920f395f5bd9a53f960435fd7ced631b205ff1f01a29cd5aee837c19b97c1"
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
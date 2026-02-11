class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.51.1.tar.gz"
  sha256 "82c83c5e7c56e132deb8feacd02216c79dbdafdfd8ccd2dc7d0bbb56b1b53a82"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c82124427d798f4cd31a732429862613745b3e72d62d844291dc222fd0b82701"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d34258ea951e66a5738a302d39917d6dfbfc5ba1056a6d5832450b8ca2b71ff3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de36296c0de19c52fe78ed14e64bec1a2cea7228da3a8162319c74b8172c646e"
    sha256 cellar: :any_skip_relocation, sonoma:        "462abd48669318c1b4dca4303dd542d2d93823c3969bff9b3801b0ad89c88729"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec61e39868aff7e65f1f5e91d3f2c1397569ad3d1ec2478dfcb6fc48c12f49dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be31c3e4b3048c1a3369adbeacd68b180ca2e37c6c77e437b6f42a9993a23e6"
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
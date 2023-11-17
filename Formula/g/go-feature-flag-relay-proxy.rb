class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghproxy.com/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "1781ff09e8d7d050da07a1c27dda1af6d06e8dfc4d7f0a9bc179950f90c10693"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdf49e3e5661a7bed61f1271b667172a1578711a940fc79a880db22d7d201bce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fe78d503f53b295d5d0e3109ebf18acff47fccb925776b81ac5650de7c15888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f87a189bd83ef12f4c8104e0dd62bf281174ca06754321e3bbd96d6671bf7bdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5aa48b029d04fa3e81f988e3062d7ee20a30360338f0d65487eda8fb0df6523f"
    sha256 cellar: :any_skip_relocation, ventura:        "8db842c3e3a00fbbceb1e7ddffcf6711cf553b20cadfa9af65eff27331719a8e"
    sha256 cellar: :any_skip_relocation, monterey:       "de722279ca639520c8d5af31d0a5793abde3ef412978b3810905631cec516fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f218e414709fc66ba430f970bc9c053760a113bc8861863798bc10de89761302"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
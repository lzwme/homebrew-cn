class GoFeatureFlag < Formula
  desc "Simple, complete, and lightweight feature flag solution"
  homepage "https://gofeatureflag.org"
  url "https://ghproxy.com/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "a0d8ae586abc8ca1bb7e2d029e17dd913268ae2131aaec6ae30ee50f033a855d"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19b6dcfb658e768029a174894088789df63560901facbe8e2cbe14fce1e31383"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19b6dcfb658e768029a174894088789df63560901facbe8e2cbe14fce1e31383"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19b6dcfb658e768029a174894088789df63560901facbe8e2cbe14fce1e31383"
    sha256 cellar: :any_skip_relocation, ventura:        "c58954851f465bd7877a09c9d015e8e4cbf32824627ee69d9688e979755a7870"
    sha256 cellar: :any_skip_relocation, monterey:       "c58954851f465bd7877a09c9d015e8e4cbf32824627ee69d9688e979755a7870"
    sha256 cellar: :any_skip_relocation, big_sur:        "c58954851f465bd7877a09c9d015e8e4cbf32824627ee69d9688e979755a7870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a0d8c5a830028c1504af6c30a187de1bd38e5fd08b60352e7acf4e4f37db15"
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
        exec bin/"go-feature-flag", "--config", "#{testpath}/test.yml"
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
class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.26.0.tar.gz"
  sha256 "0b3e16d5b6872c9292246193b1a2308cfb85c8e569e6a3cbdaa034a5b05ffb34"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "686402d0198724f6576be795046b8e6b0a5231d5db9576d8d06212e3dfac536a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81ea3e419cfbe11a11ef74a5f67c6e9d7a69072ac9a99d3614be60bf1e8df3ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e95726f70c5ad1be86b23f443cc86657dae20a4008f6e9769ae6a0d749d2908e"
    sha256 cellar: :any_skip_relocation, sonoma:         "035369b799f7467106faa60ddfcad9d86fb8e56363c95d950c48ed78767a1909"
    sha256 cellar: :any_skip_relocation, ventura:        "e26b14799812a3bde1cb6d794d01bc6cf344f58e5e413f17492704dd29ac9192"
    sha256 cellar: :any_skip_relocation, monterey:       "d2b01d73cbb40830f093aa723cc5569f649962fab623cf0cd5f2a08164f93a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "542b3ac49d7188c8ba73dcd2696cc7d8762919f2f48c62f963219534a7ceafe2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdrelayproxy"
  end

  test do
    port = free_port

    (testpath"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}flags.yml
    EOS

    begin
      pid = fork do
        exec bin"go-feature-flag-relay-proxy", "--config", "#{testpath}test.yml"
      end
      sleep 10

      expected_output = true

      assert_match expected_output, shell_output("curl -s http:localhost:#{port}health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
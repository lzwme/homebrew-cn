class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.14.0",
      revision: "2a05d11ff455211bd04702f6addd1986d132f431"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cf80d840f8f641327952ddb926a75b277955fc89e18d480251e2c61b49165f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cf80d840f8f641327952ddb926a75b277955fc89e18d480251e2c61b49165f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cf80d840f8f641327952ddb926a75b277955fc89e18d480251e2c61b49165f5"
    sha256 cellar: :any_skip_relocation, ventura:        "7148fc41ec9f1a7cff7276848a0d272a7b6bf4b969946e09d0fcbdb614804f78"
    sha256 cellar: :any_skip_relocation, monterey:       "7148fc41ec9f1a7cff7276848a0d272a7b6bf4b969946e09d0fcbdb614804f78"
    sha256 cellar: :any_skip_relocation, big_sur:        "7148fc41ec9f1a7cff7276848a0d272a7b6bf4b969946e09d0fcbdb614804f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f24c81de971febd32319e4f9bc7bc96d912e0373794b52811a7f09dffb92d970"
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
class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.10.3",
      revision: "e5fef66c8599bd6c64d0681999b883136939242d"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40553adb851c8b7a24c24061d0e160f64ca47ac5e8c55c3e8b0dd913628833ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40553adb851c8b7a24c24061d0e160f64ca47ac5e8c55c3e8b0dd913628833ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40553adb851c8b7a24c24061d0e160f64ca47ac5e8c55c3e8b0dd913628833ab"
    sha256 cellar: :any_skip_relocation, ventura:        "6734aa40e36d6b64ad0615d530ed15ab5bd01fc38830b95fcea3ebd98bfb15da"
    sha256 cellar: :any_skip_relocation, monterey:       "6734aa40e36d6b64ad0615d530ed15ab5bd01fc38830b95fcea3ebd98bfb15da"
    sha256 cellar: :any_skip_relocation, big_sur:        "6734aa40e36d6b64ad0615d530ed15ab5bd01fc38830b95fcea3ebd98bfb15da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dffbb877b9303502463c29ecfff2521831428cf99626cfeb73f621eb0db95f39"
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
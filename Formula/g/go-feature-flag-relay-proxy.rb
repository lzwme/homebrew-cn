class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghproxy.com/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "cb35686e260e2c2f62bbea09159d6c75d856cb4cba3071c7aa1bf32e7247bffc"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b65267746f279cc043ed6af137c15481da453ebec0ef068edeb2e7901d2bf40b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0fb4537040640c5db9aa3325fade05de17c76409210403cf8eee7b8de4f8d3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdf937dcc914cd5c3e9bffea3e11b0116df4c983114a9afe30dd1648910d8a6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9250e7d67a7bbc2c7621b0005c771e0a2fd09b21613af00c2adb11d87454f478"
    sha256 cellar: :any_skip_relocation, ventura:        "b4260407a0accb5204ead8c12420683f2ce8ad7173cc5e25527c7342471dd936"
    sha256 cellar: :any_skip_relocation, monterey:       "099c990c0531cc54ba6f80488d0c6c7dfe1fc0bb703c83868f7b7994a406555c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96cf942cd6f9dfd00d17a288b1357864deebb075c722d6ead75ce1f2c580370d"
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
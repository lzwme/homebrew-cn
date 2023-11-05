class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghproxy.com/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "bd3cfaada682b9c9fe3a8494dc5101a4911f621063eb81d3ebd52bbf33d1bb44"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e89a1a42e6ded9c85d9962a2a20ab2c7327215b22d12c896261e76fda2dc4830"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "945bdda6e3550a4d81453130d13db9ac3da802ee537baec46c4c93ef0dd024e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d49a7f825530a24a74e05bda6cfc38ba6699b7664cbd9f12d489610809972cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c9852477702686975faf52254c74b792be25df9b9257981288024f992e326a8"
    sha256 cellar: :any_skip_relocation, ventura:        "7e78e90bc5da84ceb554c29c2af497f4726a85590b6e6cf949f44b282b2b0ef7"
    sha256 cellar: :any_skip_relocation, monterey:       "e90f6149d83101c927116f120e30c89b52ffcbbed6aefb747453688943d0762f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8a4a5ede182f9ff8feb689fe6cd3e8dc341cbcc23737f64736b987b4667f238"
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
class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.14.1",
      revision: "1fc00e938f8612ed97f9269c48bb620038de2300"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c0d681f4ef47db28c470f1fbbdd558ac408cbb2e3dba60bb8e72e806c803ccb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c0d681f4ef47db28c470f1fbbdd558ac408cbb2e3dba60bb8e72e806c803ccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c0d681f4ef47db28c470f1fbbdd558ac408cbb2e3dba60bb8e72e806c803ccb"
    sha256 cellar: :any_skip_relocation, ventura:        "6acdd6bb48ea37ba91ef25b048b534db59f782228da50ba163c6fa8973de6871"
    sha256 cellar: :any_skip_relocation, monterey:       "6acdd6bb48ea37ba91ef25b048b534db59f782228da50ba163c6fa8973de6871"
    sha256 cellar: :any_skip_relocation, big_sur:        "6acdd6bb48ea37ba91ef25b048b534db59f782228da50ba163c6fa8973de6871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ec0ff235ee121e3f7c107abf36cbdb81431b6fd3074b08635784424eeb945c3"
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
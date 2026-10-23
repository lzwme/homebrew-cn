class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "dffa0e956e48f6d39f609265abbe7542f71c7f32c3a963b55d563f17493033c1"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71892499217d1555d105de883d133c76e77de44458dd6383198dbc6b1d6ee941"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c4eb54fdf01be5a3856023de36a6b72c9b6350fa8e0a5f34eff7734bb9674690"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d2250b61cdeba476faaf8fef21de3dbbcf03be8eb3b2fa35bc3885c2fe37cf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e05c64aa274e7ee839132e34065d1c76b80db2d3220ad5dd25818dd1ea0aee31"
    sha256 cellar: :any,                 x86_64_linux:      "ff8610774ee6d07def1e40a05278e64ecbcb6317dad384e4c06ed00b7bab7f51"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/relayproxy"
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
class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.56.1.tar.gz"
  sha256 "85341f47161ce76309abeccaa0b0ed76b684d4956360c2c0bbd5ad4790b80e2d"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3011f963e046fef67befe57555740ab0275bd58b810d75d6a03c370ac7babc6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "acd22313c78a01386ac14e23d4a8cbe56ea0e825082d0fe7647660c7affc65c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50493a18f04f8b05e497163c2c2aec28672e36dfac9de61c2bb386f1d9af367f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6e37069809d3ae44c5ecccc01d819f2b4e90b0362664f525b43aa428c49a3ec0"
    sha256 cellar: :any,                 x86_64_linux:      "e601a7351f5078e44ac0c7c7ed7e0f0bbf0c9afae064b86c499a05529ee156ad"
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
class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "193203548d4b98574521c1e4b59aa7f91a78cca16d9624271c44674c770b0618"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4a6da8921c374d1f3db59b6f2053024200e12d96828dffadba402c5455580a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c93e76ee8e1c820dccef0fba72e1d40ec293a0979d292384f6fe1a2c2d6c55f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40ceeb7219ea5517ad5759e084b84916b3ce848d53f8d5c92e3e5108ccbd116c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c7df940b8d6b24176dc9bba2b0f523dac8cdcecc15943a3a197b68372640dbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59b5db812cfd2574559fed2cf52db9463466e867cc99666a5fc6f430e012083a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45c31f75ecc7242a4a16c2c164c6c1d759cb813dd1c390bee1f16b60a6e5147a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
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
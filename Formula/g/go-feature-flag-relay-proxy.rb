class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "aae53d27ec70312cf57e0588d5237a96c4042bb0a1852d811a6757c1fdad9f71"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d198592043fde9b60de586ae57acd473365ab2a544db86baa1ac09bf16d890a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "097c8438fb35b048ec4dae81c981471f58a889b026bad792e35093faad01f7a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "902e474067ab00aef8335f91f82adde7cf38917917a10ec12573a8278c81b1bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de311b87181173c3e07df4ce6e5425517bc86a868637c479ca27949eb76e6188"
    sha256 cellar: :any,                 x86_64_linux:      "9a654af667076f43bde1914693b233001d8a64274b291afc5090f90912b64445"
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
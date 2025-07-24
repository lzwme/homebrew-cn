class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.45.5.tar.gz"
  sha256 "8e9ab7934e0d0cda86b8dbb1f6e2624b9a2aa122ad33e91e65ea7d52739e1d8e"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6d9a2de3e058b520c1e5cb0c7205c647de4da62b914ffc1a4df458e3c1fb58d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "180d159765dcc39f4ff75244c410b7bbe474570a56d33d77f41acd34a1587ee3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47392aee64b7f816e8cf30e62a36ec62094c0e1debc032137cb0d2693f2812f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eb1f266921c4c9d0303c68f1b1041c98f52f42c6c5e6723577154fb99c6ca81"
    sha256 cellar: :any_skip_relocation, ventura:       "85227c97bb007c9456d7feed53503d2eabac9354409fb5e7333cef4497c63a05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87be180fa9c608e08c7032ab13952c05640a9a55ae400ee6fba602cbeab72260"
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

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 10

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
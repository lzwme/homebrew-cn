class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.40.0.tar.gz"
  sha256 "7fead9e0f4dde339ff9c84a8d32905404ccfeff2f5b43fe48a675822338170d9"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ea927a58a56bacdb55818d12c7517d4a666238857e146bffc1ce9981e75372e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ea927a58a56bacdb55818d12c7517d4a666238857e146bffc1ce9981e75372e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ea927a58a56bacdb55818d12c7517d4a666238857e146bffc1ce9981e75372e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b89fc996d7b1b5b884f48cb45096bf3a6b980df26d6a43c3424ae6f3c825680e"
    sha256 cellar: :any_skip_relocation, ventura:       "b89fc996d7b1b5b884f48cb45096bf3a6b980df26d6a43c3424ae6f3c825680e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f8c931326ddfdda6f5d705d124d0457afe202822556bd05b06cc86e09b583b0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdrelayproxy"
  end

  test do
    port = free_port

    (testpath"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}flags.yml
    YAML

    begin
      pid = fork do
        exec bin"go-feature-flag-relay-proxy", "--config", "#{testpath}test.yml"
      end
      sleep 10

      expected_output = true

      assert_match expected_output, shell_output("curl -s http:localhost:#{port}health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
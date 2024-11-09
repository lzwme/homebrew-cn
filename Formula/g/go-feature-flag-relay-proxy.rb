class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.38.0.tar.gz"
  sha256 "13fabe8d6e7f866ac1509ed8ce8396e851aecf40a16d8b520f47cb7093371ed6"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52805f1a778f460ec9561cdf064bbc4d0b3c60b5e8e5f6b601d39ea639034970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52805f1a778f460ec9561cdf064bbc4d0b3c60b5e8e5f6b601d39ea639034970"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52805f1a778f460ec9561cdf064bbc4d0b3c60b5e8e5f6b601d39ea639034970"
    sha256 cellar: :any_skip_relocation, sonoma:        "56c4806e4e55fc50c29e71e4b670a06b4527a648fdba0c522c0bc2faa998d7c6"
    sha256 cellar: :any_skip_relocation, ventura:       "56c4806e4e55fc50c29e71e4b670a06b4527a648fdba0c522c0bc2faa998d7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99f3e191ff621ee165383a5e83d0b174a865a1714b8e1e7248b1e796ff89bf62"
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
class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.36.0.tar.gz"
  sha256 "765107b0fe4529994ea76498a4e5ec98a92e92a50a76d4835b045b696a1dbae0"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1442428baffb25e71f5afa465469e9740a7768b509e4a28b5c692aba369e9230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1442428baffb25e71f5afa465469e9740a7768b509e4a28b5c692aba369e9230"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1442428baffb25e71f5afa465469e9740a7768b509e4a28b5c692aba369e9230"
    sha256 cellar: :any_skip_relocation, sonoma:        "54c16b46cc08241b506a118b57f87e0cfec27ba24e09437fed528bec2947657b"
    sha256 cellar: :any_skip_relocation, ventura:       "54c16b46cc08241b506a118b57f87e0cfec27ba24e09437fed528bec2947657b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeb6a902f5717b2fe31fc507cad378f2ecf993ff9f775cc8286ab0b27427be86"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdrelayproxy"
  end

  test do
    port = free_port

    (testpath"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}flags.yml
    EOS

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
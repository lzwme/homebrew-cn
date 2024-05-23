class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.28.1.tar.gz"
  sha256 "d955ef6e90d658ae585f258a4ebd273c52ad175c6040ba81dba956a78b62f149"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63c7f60d7f5afc211059250d97ec9b3d66a79cb67e46e2e8ec2fd7beb209f382"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4683b455c1c3eabd404699cc10ca6d8b5b5c6910e7b0578822896c4c773425ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d54e355ba684b64204da1d4744e095f6c55a72f3ca4240ebf0e64c7761f53cb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "064a9e60c80e76b69e47bef60ef8d2cb814dfe5ec59855f734af6e63afc1a3d5"
    sha256 cellar: :any_skip_relocation, ventura:        "ceaa991197413c2c3f661ac413344a8ba3672f60a7c4063f0178398c4d47a3b3"
    sha256 cellar: :any_skip_relocation, monterey:       "07650d50fb69c48a73a44b268e933262faad1a0cf3ca758fe1fc461ef22fb55f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55dc523013b9fc5ea7ca8c445dbcef029f333d5e863a2908809d63a0bd3b0f53"
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
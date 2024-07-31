class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.32.0.tar.gz"
  sha256 "bf2275294f27b954f74eae5207fb17f3cdb45cb7b813f2c334acd41a79708d56"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10c59954b2d9eca66c3c39faf66784c80e924979b835fd20566efb410886308c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf5a34980e80c074e32939b4ecfc0fec4abfabf9fce7af67c7f0d8e855b74d96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "687194b7707dfecfffe99fc18ea5263b6e1c32876bd115d5de41824a35508682"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a9dd453acd49421ac90e614aa9fa56567ea9d223089b15f6d0d0a9335dcf1b0"
    sha256 cellar: :any_skip_relocation, ventura:        "936e3bdbe9a768669c7a220510fc09db0678d6fff3fbd25b2ca5e88e952c1506"
    sha256 cellar: :any_skip_relocation, monterey:       "5a0f0317fd8a777f026e25d1f31e167b9bd404461ef9a18d7b899921f43238eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1917cdd735ab555b1d7d14b5f399ea38f520a52f4800ea633f9db98c9ca24d2"
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
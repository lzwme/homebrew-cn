class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.24.0.tar.gz"
  sha256 "c3863da4f9f150d6d09688b9e0cd1dbda80f9e7f4af8aacf6d307c48bf1986e4"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76f0266c0a8a90aca769ce90342ed005e3f23526293614a04e087a81d3ff65f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5706936fc81a8d80566ad93fe969cc3e5dd33e6cabaea187823548a984e1539"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb074afc2463b3014fb337e276d22833d65f74d9ed698e2d94baa2083060a795"
    sha256 cellar: :any_skip_relocation, sonoma:         "355b436b570147bae58916b422c6b808f7de74e96ab19844ff8b68b25afcd8a2"
    sha256 cellar: :any_skip_relocation, ventura:        "a16fdf1e7001ac835bab6b7f073e7866c06fdb1272448747c175b3df6e9322ea"
    sha256 cellar: :any_skip_relocation, monterey:       "37c74978c0797e9d75aadf77b354bba3cd4ad67c1db156a31645d5d565c139e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5b0ff7f130f09137af3abd3bdce76af1abf1be8106da74eb01f27b5e7c9ffbe"
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
      sleep 3

      expected_output = true

      assert_match expected_output, shell_output("curl -s http:localhost:#{port}health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.28.0.tar.gz"
  sha256 "65c6d97821806f8ec503766b32a149ce1cf36502a0207f4298f41839ef3df068"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85dd39518577e0fa1f1184dbcaeeb6cd041e3d845789ef455013069d73d69d71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2850ccaa311d5a39c588d24aaaadd34d00ee1f7102c7d8fecf63bc2b6c1e09c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d056a50db03ca977a2833065c6eeb6f0d446fd4da96716c92fa3cd0242aded1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5187409ab0708087d93d8572ef62cc27b94f7e9f2b613e6592ed40e082d07150"
    sha256 cellar: :any_skip_relocation, ventura:        "3d551194ff023a9028a50fa107c19871e552fe631a0c29d7bd0a533a8f0a6c38"
    sha256 cellar: :any_skip_relocation, monterey:       "233dfadcdff0111f62e3704fb3d17e8d103f44078633a563933075ebd7020e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1714486849155dd0e899ae1bbb16df8142b129d045c78ce2a64409090ff74e9a"
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
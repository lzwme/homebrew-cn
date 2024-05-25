class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.28.2.tar.gz"
  sha256 "2563b54e8ad6ad6dbac6269f68bfdabdd2b867d634c8ee5b18c50f2eb7dd7e28"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4f59fa501dd1ec76a1566b8ff2fb8529980585b1978916df2f9fbb322918611"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d062ae549185fd8f9f424b1c208fe9b62d3c6f7156646e8a9c4c6cc935f03e21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32874fbefe9275000e9429cf14cb4502783e8e33ed866d5776f0cd181fef66c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e077034a677028eec0dfdc92ee5f47b321ffc0b786028df9d75c4221554cb7a9"
    sha256 cellar: :any_skip_relocation, ventura:        "39f361ca09cfb78ce85bd96139a7af94c5683afbf0f85fb1af5704a39261ce45"
    sha256 cellar: :any_skip_relocation, monterey:       "0f02e3d70b2831e48773ab8f7be06bfb639dd30a88e38f93da3bfacd038bb737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b2ee3d4c67ada073adb8798132e4681e1163f03edacfb900305171da4e43f9b"
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
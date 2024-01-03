class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.20.2.tar.gz"
  sha256 "b5c0ac6b96f0f0713310434f43843ee3020f248d181352bbae26241133479f92"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35d0f95d6517396314c09b963317f0aea1709d0f5f450e39ffebaeda6e0fc3d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8462ce050eca50c10136b58ba37432ae36744e0fb1edfd786bc6fee43309690c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78703bf3a71259084a3be5db6f5f8ad84d216c15b7b873bb7a1132582cb7d14d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a275d8fadbdaae954758840aedaa42f7decb6a0f09e09ed551da13991e133c8"
    sha256 cellar: :any_skip_relocation, ventura:        "e868e96aea3b157de4be21d74c27e9f1b7070cfe38a145f59121519d89be10bc"
    sha256 cellar: :any_skip_relocation, monterey:       "2ecb764df9bec6fcf64bf0d24374c5a1612f087add77bcc5db64f54e4ffe68ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6721b48c6d630d9af2c95a4a837ff7e2bb605c11537d125017f80988b3c580df"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdrelayproxy"
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
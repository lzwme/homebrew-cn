class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.37.1.tar.gz"
  sha256 "0e9b8aea3d1df4ebed87710b99950e0a363cd771ec69f0dbd272dc8f25739a80"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b548cb231c9fb2f2f21ad9808089f868a006ee16060eb7116e0cb2f5b7cd8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87b548cb231c9fb2f2f21ad9808089f868a006ee16060eb7116e0cb2f5b7cd8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87b548cb231c9fb2f2f21ad9808089f868a006ee16060eb7116e0cb2f5b7cd8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3a98943ab602e6ef1ebdd3636889bf0b0bea8d6e2f6a7500969228804c2044d"
    sha256 cellar: :any_skip_relocation, ventura:       "a3a98943ab602e6ef1ebdd3636889bf0b0bea8d6e2f6a7500969228804c2044d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32f8c94f2065318e70989f10519cbdeda7a327f46d5b25c6c4d1c08a8e04caaa"
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
class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.12.1",
      revision: "8c17cff4bb7ecc598eb0f8a5e4f159f3980db637"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8ae305a318dc9db27321d41df377c5b164fb1f5005c1270b3635553bcf728be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8ae305a318dc9db27321d41df377c5b164fb1f5005c1270b3635553bcf728be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8ae305a318dc9db27321d41df377c5b164fb1f5005c1270b3635553bcf728be"
    sha256 cellar: :any_skip_relocation, ventura:        "fdef9659723fff16c22cfffc600c6c83e464a53b0d61133cbb6ca496faad02d2"
    sha256 cellar: :any_skip_relocation, monterey:       "fdef9659723fff16c22cfffc600c6c83e464a53b0d61133cbb6ca496faad02d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdef9659723fff16c22cfffc600c6c83e464a53b0d61133cbb6ca496faad02d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b4d20492f1ffc56d122f1f814257b96220c74e4295c1c66b910ab20dd085419"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath/"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    EOS

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 3

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.7.0",
      revision: "d6f9f1b18345bb7187bb6affb4168a4949a36e34"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23fbe3ee18f3e11aa8d5c3d7f42888d7e5e799965231da99e30dfb91495751aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23fbe3ee18f3e11aa8d5c3d7f42888d7e5e799965231da99e30dfb91495751aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23fbe3ee18f3e11aa8d5c3d7f42888d7e5e799965231da99e30dfb91495751aa"
    sha256 cellar: :any_skip_relocation, ventura:        "fff703f3374440a1d74227682ecbaacab2a93598c04e33deecafb9c445fe6476"
    sha256 cellar: :any_skip_relocation, monterey:       "fff703f3374440a1d74227682ecbaacab2a93598c04e33deecafb9c445fe6476"
    sha256 cellar: :any_skip_relocation, big_sur:        "fff703f3374440a1d74227682ecbaacab2a93598c04e33deecafb9c445fe6476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c02ab94574fe3a917d73650b05320d635c5c3c125ef1034037726686cf79be7f"
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
class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.47.1.tar.gz"
  sha256 "eb2978084930132f590111d4689cd3d71d2499ab47bcba399d243c0d495cd3e3"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2f8125e2232974ff99310de4fcee932a1c7cfceacac2cf6cc29bac3a4a1b17b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22953d4505c60b946e33e282a8ae93e5734e823c5d64afa280b05c1d134bff63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8297d6b9b783274e81639686ab564c26c1eb26dee119ac3d668a925296fc750b"
    sha256 cellar: :any_skip_relocation, sonoma:        "77c29afa7c432042bfe67455d9f4f426ec70a02079142554be290578075f8c75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17e9e910fc0bd7c6f1a171aa51be2270c1314484ece6d01e29979cf942b34548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba2a86fc3798ca92752fccf3872689dd16e54aee9660d5ad6297405dcee23325"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath/"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    YAML

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 10

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
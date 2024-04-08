class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.25.0.tar.gz"
  sha256 "61425daa154acdd6144e756ce7d3f6039be9bb052f5f386f070aadbdf14929d8"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f7d289eac0366ad3c31d2e271c2d759f35507340ac0dc80aa014a4e89b411bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41ab8d863615a53a8c54b0f52ce21e9b25302b5102dd5cbe7ddf845970547013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a56086e13912c436d342e8b619244582b8344b7b94ba281e1e83cf10b90958d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0aac7ec372c9a7fcb60bd1a9feab48893c54554c36d770477472bf487d2e1af3"
    sha256 cellar: :any_skip_relocation, ventura:        "65b6e37bc2ba8f8fafedcf9274bda32cde18a47983df0a0e98ef3bef9d8c31ff"
    sha256 cellar: :any_skip_relocation, monterey:       "cd4e268178983eedb998af75d777eec45c0de8c7aa8db5f307b6f1c8c80c70c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198cd495dfc38782c8e7a8870ad54c9788c35602d691e1fdfa2ed4f07ca5e0ba"
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
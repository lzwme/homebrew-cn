class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.34.3.tar.gz"
  sha256 "0a2cf1e53e9c0c1e3e9d0746a6cdfc435a4e67ff21d24153adbfd407ae02aa6a"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59bff5ddb65b746f3203265918c411188cfff3ccfc0f621a18ce8ae2c55cfb54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59bff5ddb65b746f3203265918c411188cfff3ccfc0f621a18ce8ae2c55cfb54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59bff5ddb65b746f3203265918c411188cfff3ccfc0f621a18ce8ae2c55cfb54"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cc604c8c0c46d844e71eca8751fbc034499cecb8460f02d086b94d4ba88d509"
    sha256 cellar: :any_skip_relocation, ventura:       "4cc604c8c0c46d844e71eca8751fbc034499cecb8460f02d086b94d4ba88d509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cf1f436ad1966579bd7d8241c441be7da83feea052a4c7f015705d85b6d4341"
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
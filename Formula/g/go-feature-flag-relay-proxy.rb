class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.39.1.tar.gz"
  sha256 "481cafa05e876237e132281ed0d6e4ee6ed12162959f5f7dc1ee4f1860dfa321"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c85a3c63d1e91f55b210a21c4731908174b73b0e686f9ddd8214d5b33dd66d20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c85a3c63d1e91f55b210a21c4731908174b73b0e686f9ddd8214d5b33dd66d20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c85a3c63d1e91f55b210a21c4731908174b73b0e686f9ddd8214d5b33dd66d20"
    sha256 cellar: :any_skip_relocation, sonoma:        "25df8ab90d65920d59fccdafbc4f3e8d82c81ae66c3e5b251796e7a423e1c564"
    sha256 cellar: :any_skip_relocation, ventura:       "25df8ab90d65920d59fccdafbc4f3e8d82c81ae66c3e5b251796e7a423e1c564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c9840b9c7b50dff851a0a1cf0967699e62472442e85d5b0f67a72535f3882b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdrelayproxy"
  end

  test do
    port = free_port

    (testpath"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}flags.yml
    YAML

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
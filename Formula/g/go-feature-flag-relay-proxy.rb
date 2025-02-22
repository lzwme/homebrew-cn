class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.41.3.tar.gz"
  sha256 "629770937c4895f90a1d1510de87a1539a0f9556c2f1907b819f389000e123a3"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "833836850a14e91a1cef03c22ad0195fa7fb7da4610c6709e9fe018d2742d1fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "833836850a14e91a1cef03c22ad0195fa7fb7da4610c6709e9fe018d2742d1fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "833836850a14e91a1cef03c22ad0195fa7fb7da4610c6709e9fe018d2742d1fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f5c1c4cfb18e18f461cefafc609e863638aefbda46fa81288cb7988fb457284"
    sha256 cellar: :any_skip_relocation, ventura:       "4f5c1c4cfb18e18f461cefafc609e863638aefbda46fa81288cb7988fb457284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6f890d28a20ace286e0a6231e74f1f304245323748a4b77f14acaa094f2b18e"
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
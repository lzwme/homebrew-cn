class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.10.0",
      revision: "9679c97200d1db8d2770a8b49f6a1aa9fa1f9419"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "385770b38ec91a0076ea103133adadce61dd7ea0d43184b50c4b56d32de3894b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "460b70c233ce243c2e34c1a03fbed1eed162fa9f9abb43911eb01aeafb2217b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "460b70c233ce243c2e34c1a03fbed1eed162fa9f9abb43911eb01aeafb2217b6"
    sha256 cellar: :any_skip_relocation, ventura:        "0b87cf4fc6f61dede0a185990c4da3f9fc6a108f910f8b655d5f2ae4828f6117"
    sha256 cellar: :any_skip_relocation, monterey:       "ddf137770fafc829420cf83c090110a32dafd954dcd34b72fa1ccbbd496d9b99"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddf137770fafc829420cf83c090110a32dafd954dcd34b72fa1ccbbd496d9b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "786c83d2b7cf370db3fbce5a21c278df8568712c1125f9b7796138d6f42217c4"
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
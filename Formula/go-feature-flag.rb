class GoFeatureFlag < Formula
  desc "Simple, complete, and lightweight feature flag solution"
  homepage "https://gofeatureflag.org"
  url "https://ghproxy.com/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "1086b5b15bb2c3bdb0614b1d81639419585c2e7f3c00c8d65b1c4048e565575f"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bc58a02ead8643851e7ba694e73aaef54d48462e2a410c965566660ac254a50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bc58a02ead8643851e7ba694e73aaef54d48462e2a410c965566660ac254a50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bc58a02ead8643851e7ba694e73aaef54d48462e2a410c965566660ac254a50"
    sha256 cellar: :any_skip_relocation, ventura:        "0697bf2d69597f596a8e0187e6e349a19cc490c46dbd6af8e4afece24d657ad3"
    sha256 cellar: :any_skip_relocation, monterey:       "0697bf2d69597f596a8e0187e6e349a19cc490c46dbd6af8e4afece24d657ad3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0697bf2d69597f596a8e0187e6e349a19cc490c46dbd6af8e4afece24d657ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb50031a763ea1c59ef0ac49dce693ac64714e2b1642533d72077cf499f5b9bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
        exec bin/"go-feature-flag", "--config", "#{testpath}/test.yml"
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
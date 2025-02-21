class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.41.2.tar.gz"
  sha256 "9d3ba8a560e000f2566e78f294903888bd61f466c05f1900c6b72ef73a367092"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a24a2066291742382e9c23f8d3ab21c412d16cea8a4a01bd834b12544591c396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a24a2066291742382e9c23f8d3ab21c412d16cea8a4a01bd834b12544591c396"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a24a2066291742382e9c23f8d3ab21c412d16cea8a4a01bd834b12544591c396"
    sha256 cellar: :any_skip_relocation, sonoma:        "393174f6cd888c36423897228b7478cb5e86f720345e149c5db7fe56186f366f"
    sha256 cellar: :any_skip_relocation, ventura:       "393174f6cd888c36423897228b7478cb5e86f720345e149c5db7fe56186f366f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1588e03db0648bc92dc714eabdabf68f81b9e84b9a1c2fe7ad1d5fc2a4ce715"
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
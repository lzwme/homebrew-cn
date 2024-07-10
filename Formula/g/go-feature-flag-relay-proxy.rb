class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.31.1.tar.gz"
  sha256 "2aa0518cb315e3f53cfd32ef3f1632c99a7c435cbb6a62272124f99cab554b83"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5da8eb86c354ea219e0bdbc7456e04ad6ace9444104efeebb2ae29e8ffada27d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7abe71be336de8bc1f4125e3f51ced8dbed6fc1d8b880ea66aa71c45ccaff879"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66711ac4ddfa67a5905fde883ffbe9d6945883b231617b3ced3c4ec189bfe5c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "107714263507a0a7b9cc193348c455d77dd96089703c983c61baf72b6659d2aa"
    sha256 cellar: :any_skip_relocation, ventura:        "e628b2486e987f81334a2faa4aca8d70062350842fc5fad5f755f37299ad91f5"
    sha256 cellar: :any_skip_relocation, monterey:       "cb9b05bcf1262a35bbc9ad1cdc8c810d7be11170a7050e92421abd353f5a59a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f976b0626a75273b167c7b55af6679286d6646bfac4ae6734356a695b5949c6"
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
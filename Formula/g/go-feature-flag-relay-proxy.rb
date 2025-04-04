class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.43.0.tar.gz"
  sha256 "81c8046bb8a9ea235af12af51c341306bb6e9812f43ea1f7bb17f70885d476f5"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0610468dd3908b4358fa1fd9b1bdfee03574cf9d95856fca0548b61e2c409233"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa8511ea6a8307fd362dd36334e9cf2d528b779c09bb894913c2daf12f8eb05b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52a9d8fbe4fb8ce614ead4622f7585bc988bb082fc324df8839a31b086dad663"
    sha256 cellar: :any_skip_relocation, sonoma:        "e019f9607813d388a2da4e18a2ebb74ed7ca1bf8a2c7902808c9a36f7792d31f"
    sha256 cellar: :any_skip_relocation, ventura:       "0b3f1e7b72b54806408bedbc095f379f904029663728c71911c5b40fc3c38a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c66fc0a32b44295d90727a758c04fedfba4750fc82a08b4310fc32d71f904b46"
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
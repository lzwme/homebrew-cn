class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.21.0.tar.gz"
  sha256 "d12f2c2dc791a47467a02dd102fc2732f60ab272e0e02db191ebface1b9c745f"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d757d2646d299c4ace34cbe3838d62a9b75d44f15d00a006acaa49310af9a85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af5ea49168b86d21978fb4ad41c3b84bad27e823986573292b12f685c171c223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "908169000c2f28a7878ee8b6bcbbc3b086e5179c57cdba416eba24ef3e34da76"
    sha256 cellar: :any_skip_relocation, sonoma:         "01edfc7eb13cf549f12760cf68536c7b80a45e29139e5b66933cec5606f41c40"
    sha256 cellar: :any_skip_relocation, ventura:        "395fe1311ca0d4ede3305c776d13c7fc31a7dc9d32ce04103e7eed53c6eaa061"
    sha256 cellar: :any_skip_relocation, monterey:       "817ba330b150286d8bdb786d9eededf95fef1b962bec1e99f8d2a37f064c9aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e13260f0d80de287cb122cbb8049003ff256485c7602fd908f5a66e05b755c1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdrelayproxy"
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
      sleep 3

      expected_output = true

      assert_match expected_output, shell_output("curl -s http:localhost:#{port}health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end